- Sửa lại màn hình LoginScreen đẹp hơn 
- khi ấn login google, apple khi chưa có tài khoản thì không đăng kí và đăng nhập vào app
báo log khi ấn :D/FirebaseSessions( 1827): App backgrounded on com.dinos.foodtour
  D/FirebaseSessions( 1827): App foregrounded on com.dinos.foodtour
  W/Parcel  ( 1827): Expecting binder but got null!
  D/FirebaseSessions( 1827): App backgrounded on com.dinos.foodtour
  E/OpenGLRenderer( 1827): Unable to match the desired swap behavior.
  W/.dinos.foodtour( 1827): Cleared Reference was only reachable from finalizer (only reported once)
  I/.dinos.foodtour( 1827): Background young concurrent copying GC freed 13MB AllocSpace bytes, 160(7216KB) LOS objects, 69% free, 9326KB/29MB, paused 18.308ms,92us total 148.655ms
  W/.dinos.foodtour( 1827): Reducing the number of considered missed Gc histogram windows from 104 to 100
  I/FA      ( 1827): Application backgrounded at: timestamp_millis: 1775635568521
  D/FirebaseSessions( 1827): App foregrounded on com.dinos.foodtour
  W/WindowOnBackDispatcher( 1827): sendCancelIfRunning: isInProgress=falsecallback=android.app.Activity$$ExternalSyntheticLambda0@f5e6707
nhưng không tự đăng kí và đăng nhập vào app
-  khi login vào các api báo địa điểm lỗi I/flutter ( 1827): Lỗi tải quán ăn trên Map: LateInitializationError: Field 'apiClient' has not been initialized.
- khi đăng nhập bằng email thì có nút ghi nhớ tài khoản mật khẩu vào thiết bị 
- sửa lại popup xác nhận cho đẹp hơn -> nên tạo 1 popup thông báo dùng chung
- cân nhắc xem sửa lại giao diện các màn chia sẻ, danh sách, tôi,detail để đồng bộ với nhau để đẹp hơn