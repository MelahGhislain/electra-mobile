String average(double amount, int count) {
  if (count == 0) return '0.00';
  return (amount / count).toStringAsFixed(2);
}
