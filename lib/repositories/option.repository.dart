import 'package:miss_minutes/api/classes/api.option.class.dart';
import 'package:miss_minutes/api/services/api.options.service.dart';
import 'package:miss_minutes/classes/option.class.dart';

class OptionRepository{
  final ApiOptionsService _apiOptionsService = ApiOptionsService();

  Future<List<Option>> getOptions() async{
    final List<ApiOption> apiOptions = await _apiOptionsService.getOptions();
    return apiOptions.map((apiOption) => Option.fromApi(apiOption)).toList();
  }
}