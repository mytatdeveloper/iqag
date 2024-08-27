class ServerInformation {
  List<Servers>? servers;

  ServerInformation({this.servers});

  ServerInformation.fromJson(Map<String, dynamic> json) {
    if (json['servers'] != null) {
      servers = <Servers>[];
      json['servers'].forEach((v) {
        servers!.add(Servers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(response) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (servers != null) {
      data['servers'] = servers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Servers {
  String? id;
  String? clientName;
  String? ip;
  String? domainName;
  String? logo;
  String? colorOption1;
  String? colorOption2;
  String? fontsize1;
  String? fontsize2;
  String? button1;
  String? button2;

  Servers(
      {this.id,
      this.clientName,
      this.ip,
      this.domainName,
      this.logo,
      this.colorOption1,
      this.colorOption2,
      this.fontsize1,
      this.fontsize2,
      this.button1,
      this.button2});

  Servers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientName = json['client_name'];
    ip = json['ip'];
    domainName = json['domainName'];
    logo = json['logo'];
    colorOption1 = json['colorOption1'];
    colorOption2 = json['colorOption2'];
    fontsize1 = json['fontsize1'];
    fontsize2 = json['fontsize2'];
    button1 = json['button1'];
    button2 = json['button2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client_name'] = clientName;
    data['ip'] = ip;
    data['domainName'] = domainName;
    data['logo'] = logo;
    data['colorOption1'] = colorOption1;
    data['colorOption2'] = colorOption2;
    data['fontsize1'] = fontsize1;
    data['fontsize2'] = fontsize2;
    data['button1'] = button1;
    data['button2'] = button2;
    return data;
  }
}
