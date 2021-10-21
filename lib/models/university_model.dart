class UniversityVM {
  String? alphaTwoCode;
  List<String>? webPages;
  String? name;
  String? country;
  List<String>? domains;
  String? stateProvince;

  UniversityVM(
      {this.alphaTwoCode,
      this.webPages,
      this.name,
      this.country,
      this.domains,
      this.stateProvince});

  UniversityVM.fromJson(Map<String, dynamic> json) {
    alphaTwoCode = json['alpha_two_code'];
    webPages = json['web_pages'].cast<String>();
    name = json['name'];
    country = json['country'];
    domains = json['domains'].cast<String>();
    stateProvince = json['state-province'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alpha_two_code'] = this.alphaTwoCode;
    data['web_pages'] = this.webPages;
    data['name'] = this.name;
    data['country'] = this.country;
    data['domains'] = this.domains;
    data['state-province'] = this.stateProvince;
    return data;
  }
}
