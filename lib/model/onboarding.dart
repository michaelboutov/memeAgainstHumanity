import '../utils/image_utils.dart';

class OnBoardingModel {
  const OnBoardingModel(this.image, this.title, this.subTitle);

  final String image;
  final String title;
  final String subTitle;

  static List<OnBoardingModel> onboardingSlides(bool isDark) {
    return [
      OnBoardingModel(
        ImageUtils.slide1Light,
        'play with your frinds',
        ' fun social game ',
      ),
      OnBoardingModel(
        ImageUtils.slide2Light,
        'create room and get youre frinds in with id',
        'meme and fun together ',
      ),
      OnBoardingModel(ImageUtils.slide3Light, 'up to 8 players',
          'gif, meme , and best way to spend time together ')
    ];
  }
}
