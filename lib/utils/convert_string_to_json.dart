
class ConvertValues {

  Map<String, dynamic> convertStringToMap(String dps) {
    List<String> keyValuePairs =
    dps.replaceAll('{', '').replaceAll('}', '').split(',');
    Map<String, dynamic> dataMap = {};
    for (String pair in keyValuePairs) {
      List<String> parts = pair.split('=');
      String key = parts[0].trim();
      String value = parts[1].trim();
      dataMap[key] = _parseValue(value);
    }

    return dataMap;
  }

  dynamic _parseValue(String value) {
    if (value == 'true' || value == 'false') {
      return value == 'true';
    } else if (RegExp(r'^\d+$').hasMatch(value)) {
      return int.parse(value);
    } else if (RegExp(r'^\d*\.\d+$').hasMatch(value)) {
      return double.parse(value);
    } else {
      return value;
    }
  }

}