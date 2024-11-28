class PricingCalculator{

  static double calculatePrice(double price, double discount){
    return price - (price * discount / 100);
  }

  static double calculateDiscount(double price, double discountedPrice){
    return (price - discountedPrice) / price * 100;
  }
}