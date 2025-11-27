import 'dart:math';

String generateKey(int length) {
  const numbers = '0123456789';
  const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lower = 'abcdefghijklmnopqrstuvwxyz';
  const special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  final allChars = numbers + upper + lower + special;
  final random = Random();

  final keyChars = [
    numbers[random.nextInt(numbers.length)],
    upper[random.nextInt(upper.length)],
    lower[random.nextInt(lower.length)],
    special[random.nextInt(special.length)],
  ];

  for (int i = keyChars.length; i < length; i++) {
    keyChars.add(allChars[random.nextInt(allChars.length)]);
  }

  keyChars.shuffle(random);

  return keyChars.join();
}
