require('dotenv').config();
const fs = require('fs');
const csv = require('csv-parser');
const { createClient } = require('@supabase/supabase-js');
const axios = require('axios');

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_KEY);

async function getCoordinates(name, address) {
    const cleanAddress = address
        .replace(/P\.|Phường|Q\.|Quận|Ng\.|Ngõ|Ngách|Đ\.|Đường/gi, '')
        .replace(/\d{5,6}/g, '')
        .trim();

    const queries = [
        address,
        cleanAddress,
        `${name}, Hà Nội`,
        name
    ];

    for (const q of queries) {
        if (!q || q.length < 3) continue;
        try {
            // Giới hạn tìm kiếm trong lãnh thổ Việt Nam (countrycodes=vn) để tăng độ chuẩn xác
            const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(q)}&countrycodes=vn&limit=1`;
            const res = await axios.get(url, { headers: { 'User-Agent': 'FoodTourApp_v2' } });

            if (res.data && res.data.length > 0) {
                return { lat: parseFloat(res.data[0].lat), lng: parseFloat(res.data[0].lon) };
            }
        } catch (error) {
            // Bỏ qua để thử từ khóa tiếp theo
        }
        // Bắt buộc phải nghỉ 1 giây giữa mỗi lần tìm để API không khóa IP của bạn
        await new Promise(resolve => setTimeout(resolve, 1000));
    }
    return null; // Thử hết 4 cách vẫn không ra
}

async function startImport() {
    const results = [];
    console.log("Đang đọc file data.csv...");

    fs.createReadStream('data.csv')
        .pipe(csv())
        .on('data', (data) => results.push(data))
        .on('end', async () => {
            console.log(`Bắt đầu xử lý ${results.length} quán ăn... Quá trình này sẽ hơi lâu vì cần rà soát kỹ GPS.`);

            let successCount = 0;
            let failCount = 0;

            for (const row of results) {
                const name = row['Name'];
                const address = row['Address'];
                const type = row['Type'];
                const price = row['Price'] || 'Đang cập nhật';

                let rating = parseFloat(row['Rating']);
                if (isNaN(rating)) rating = 5.0;

                let image_urls = [];
                if (row['Images'] && row['Images'].startsWith('http')) {
                    image_urls.push(row['Images'].trim());
                }

                if (!name || !address) continue;

                process.stdout.write(`⏳ Đang dò GPS cho: ${name}... `); // Dùng process.stdout để in trên cùng 1 dòng

                // GỌI HÀM TÌM KIẾM MỚI TẠI ĐÂY
                const coords = await getCoordinates(name, address);
                const location = coords ? `POINT(${coords.lng} ${coords.lat})` : null;

                const { error } = await supabase.from('restaurants').insert([{
                    name: name,
                    address: address,
                    type: type,
                    price: price,
                    image_urls: image_urls,
                    rating: rating,
                    description: row['Review'] || 'Chưa có mô tả',
                    location: location
                }]);

                if (error) {
                    console.log(`❌ Lỗi lưu dữ liệu: ${error.message}`);
                    failCount++;
                } else {
                    console.log(`✅ Lưu thành công! ${coords ? '(Đã có GPS)' : '(Vẫn rớt GPS)'}`);
                    successCount++;
                }

                await new Promise(resolve => setTimeout(resolve, 1000));
            }

            console.log("=====================================");
            console.log(`🎉 HOÀN THÀNH! Thành công: ${successCount} | Thất bại: ${failCount}`);
            console.log("=====================================");
        });
}

startImport();