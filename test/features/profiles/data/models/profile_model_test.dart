import 'dart:convert';

import 'package:griot_app/profile/data/models/profile_model.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const int tYear = 1980;
  const int tDay = 16;
  const int tMonth = 12;

  ProfileModel tProfileModel = ProfileModel(
    id: 1,
    profilePicture:
        "https://griot-memories-data.s3.amazonaws.com/profile_pictures/3x4.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAVZTSDT4BLBJVSJPJ%2F20230619%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230619T123155Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEDQaCXVzLWVhc3QtMSJHMEUCIGPtzaZ15l6VnKdnv7aZHeiIvAjmKSsDLTrRC87oJeCEAiEA%2FLREzQwvt4PXfsBMlL4WES01J62Y5gA8XdHXKihIFHUqxQUIjf%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwzOTg1OTc1MjkzNDYiDJ7RvKDs4%2BAWZaGWDCqZBX%2F1XavjiHs3F16HZeLAFXozvkeIa%2BqxP%2BFtLwQJHYryqKWfiJr%2FwScTkvO1h6HqCMuAD8rkUXCTzpTnwJ9M82MAgkJ2IPagDJL%2FWFw3s6%2FNcXV%2FsF7Vhv%2B1K9QK%2BCRfedfWhTyGGxzSSxZTOGpj08Lfwt5xk5fovRT435pI4JZWDv5ltZIg6GsmbEibaG%2FlVi21%2FcxWkVaKWu41m1%2FisyC3KVc8zpUiZ8GU0PfyhG3zr%2FQPOWqsDrXgzdqNDal8nfvXNhbFWM1Czixo2uuBvVZzbWO%2Bq5V3%2BZne6wYnA1DZ09zBTv9cmYi4TlGiApJce8QvJV5CMZzEWmAiLMRURu%2FDEbtN0LCTNdlag9FDLQJ3oCCiC4V5s5A%2Bf0qMyg65AEM7awhYC1ZTx23dUX93v7rFlP2DwQnoFRtVfb4CNH2v4dTbmKYs6%2FPqoq1XzDd94iQTrwTJXofdYPyuJDwXwyErJlk1QOMIZDUqUNQ1BgVrPHEFcEhciLbBt5KJM5hf8ogVKuNVo7gQCnihLg%2FZCiSAO5yUOu1szYvfKpJrZc68Lgu1vYt9hPYXPCQcVGt8iuXMwvC5CqXL65pxCdmvkMGrPUyB%2BJBUYv2zBiv8YAqMUWgp3%2FPsQHmVRY%2FlCCmJ8xozqJhNCLx0mFDiNoBciu6nYQyxiMVSf7XMv%2B%2Fxl2RjT%2F98wOJxWiRivoBrs3PHcWIY6YkUQFe4mI3SciaSXgHEz1ODJ4c90cTzn974krCq5O2hzqrW6dK1LWOASbqp2AkD3dUeR5VgVq%2F3zdEL4oxlxv98PPKPE4durZQv5MwP4ajdUc24iZm1Jlsujz%2FEj186OZu4bZWeo%2FEo9gvau5CFcUtZ8UtWgb42lTGzesqs733u%2BBG86BVrMLGIwaQGOrEBmZtPATiVs927TwtFX8MJkMVjlGbc7d7mf5oHXaYi1380BNk3amJgV80MLWdTSlc4ku%2BCN9aINzlCUUIOZVrTJS267QOkjNiM0p%2FK0aLTSDuTxIVm8srkFWCc%2FPJd86exiyZFF4e4X%2FF4Ygw1VaWEu%2FFkfSmcnsbcM7pkhHKDK3PAXzC9TB6W8L%2F3O%2Bg3b2%2BscmqCNrb5ukUUOtTLDT0o1h0L1OZKAyI2O6ECczQHz9Sx&X-Amz-Signature=1aa9d866b1db051691427ce90adc1465bfb0c7873f3a1fce25be7485ff587dc2",
    name: "Pedro Paulo",
    middleName: "Brasil",
    lastName: "de Assis Ribeiro",
    birthDate: DateTime(tYear, tMonth, tDay),
    gender: "male",
    language: "pt",
    timeZone: "America/Sao_Paulo",
  );

  test(
    'Should be a subclass of Profile entity',
    () async {
      expect(tProfileModel, isA<Profile>());
    },
  );

  group('fromJson', () {
    test('Should return a valid profile model from a valid JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('profile_details_success.json'));
      // act
      final result = ProfileModel.fromJson(jsonMap);
      // assert
      expect(result, tProfileModel);
    });
    test('Should handle null profile picture from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('profile_details_no_picture.json'));
      // act
      final result = ProfileModel.fromJson(jsonMap);
      // assert
      expect(result.profilePicture, null);
      // you can add additional asserts to check other fields if you want
    });

    test('Should handle null middle name from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('profile_details_no_middle_name.json'));
      // act
      final result = ProfileModel.fromJson(jsonMap);
      // assert
      expect(result.middleName, null);
      // you can add additional asserts to check other fields if you want
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data for a profile',
        () async {
      // act
      final result = tProfileModel.toJson();
      // assert
      final expectedMap = {
        "id": 1,
        "profile_picture":
            "https://griot-memories-data.s3.amazonaws.com/profile_pictures/3x4.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAVZTSDT4BLBJVSJPJ%2F20230619%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230619T123155Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEDQaCXVzLWVhc3QtMSJHMEUCIGPtzaZ15l6VnKdnv7aZHeiIvAjmKSsDLTrRC87oJeCEAiEA%2FLREzQwvt4PXfsBMlL4WES01J62Y5gA8XdHXKihIFHUqxQUIjf%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwzOTg1OTc1MjkzNDYiDJ7RvKDs4%2BAWZaGWDCqZBX%2F1XavjiHs3F16HZeLAFXozvkeIa%2BqxP%2BFtLwQJHYryqKWfiJr%2FwScTkvO1h6HqCMuAD8rkUXCTzpTnwJ9M82MAgkJ2IPagDJL%2FWFw3s6%2FNcXV%2FsF7Vhv%2B1K9QK%2BCRfedfWhTyGGxzSSxZTOGpj08Lfwt5xk5fovRT435pI4JZWDv5ltZIg6GsmbEibaG%2FlVi21%2FcxWkVaKWu41m1%2FisyC3KVc8zpUiZ8GU0PfyhG3zr%2FQPOWqsDrXgzdqNDal8nfvXNhbFWM1Czixo2uuBvVZzbWO%2Bq5V3%2BZne6wYnA1DZ09zBTv9cmYi4TlGiApJce8QvJV5CMZzEWmAiLMRURu%2FDEbtN0LCTNdlag9FDLQJ3oCCiC4V5s5A%2Bf0qMyg65AEM7awhYC1ZTx23dUX93v7rFlP2DwQnoFRtVfb4CNH2v4dTbmKYs6%2FPqoq1XzDd94iQTrwTJXofdYPyuJDwXwyErJlk1QOMIZDUqUNQ1BgVrPHEFcEhciLbBt5KJM5hf8ogVKuNVo7gQCnihLg%2FZCiSAO5yUOu1szYvfKpJrZc68Lgu1vYt9hPYXPCQcVGt8iuXMwvC5CqXL65pxCdmvkMGrPUyB%2BJBUYv2zBiv8YAqMUWgp3%2FPsQHmVRY%2FlCCmJ8xozqJhNCLx0mFDiNoBciu6nYQyxiMVSf7XMv%2B%2Fxl2RjT%2F98wOJxWiRivoBrs3PHcWIY6YkUQFe4mI3SciaSXgHEz1ODJ4c90cTzn974krCq5O2hzqrW6dK1LWOASbqp2AkD3dUeR5VgVq%2F3zdEL4oxlxv98PPKPE4durZQv5MwP4ajdUc24iZm1Jlsujz%2FEj186OZu4bZWeo%2FEo9gvau5CFcUtZ8UtWgb42lTGzesqs733u%2BBG86BVrMLGIwaQGOrEBmZtPATiVs927TwtFX8MJkMVjlGbc7d7mf5oHXaYi1380BNk3amJgV80MLWdTSlc4ku%2BCN9aINzlCUUIOZVrTJS267QOkjNiM0p%2FK0aLTSDuTxIVm8srkFWCc%2FPJd86exiyZFF4e4X%2FF4Ygw1VaWEu%2FFkfSmcnsbcM7pkhHKDK3PAXzC9TB6W8L%2F3O%2Bg3b2%2BscmqCNrb5ukUUOtTLDT0o1h0L1OZKAyI2O6ECczQHz9Sx&X-Amz-Signature=1aa9d866b1db051691427ce90adc1465bfb0c7873f3a1fce25be7485ff587dc2",
        "name": "Pedro Paulo",
        "middle_name": "Brasil",
        "last_name": "de Assis Ribeiro",
        "birth_date": "1980-12-16T00:00:00.000",
        "gender": "male",
        "language": "pt",
        "timezone": "America/Sao_Paulo",
      };
      expect(result, expectedMap);
    });
  });
}
