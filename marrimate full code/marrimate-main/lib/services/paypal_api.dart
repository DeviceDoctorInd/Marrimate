
class PaypalApi{
  static const String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  // static const String domain = "https://api.paypal.com"; // for production mode
  static const String clientId =
      'AWgO72gtvmAWSDtU5aIUnxmX3Qo7NU3IjHOHDrT7rHaeqtRVbVaYTabnZ9JZ4CD4BZ4wB02tehTSZ_tV';
  static const String secret =
      'EKPuYmVgAndHl_5T77_hOt9jQbe4lv4HpFwGfkvFezRK9CaAEMKQwDbR_nvG8--UOlVojpeEpM2_Rjye';
  static const String cancelUrl = "https://samplesite.com/cancel";
  static const String returnUrl = "https://samplesite.com/return";
}