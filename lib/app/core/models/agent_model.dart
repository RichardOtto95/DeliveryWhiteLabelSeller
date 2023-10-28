import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  String? avatar;
  String? fullname;
  String? username;
  dynamic birthday;
  String? cpf;
  String? rg;
  String? issuingAgency;
  String? gender;
  String? id;
  String? phone;
  String? status;
  String? bank;
  String? agency;
  String? agencyDigit;
  String? account;
  String? accountDigit;
  // String? operation;
  // String? cep;
  // String? city;
  // String? state;
  String? country;
  // String? neighborhood;
  // String? address;
  // String? number;
  // String? addressComplement;
  // String? digit;
  // String? mainAddress;
  String? missionInProgress;
  Timestamp? createdAt;
  int? newNotifications;
  int? newRatings;
  int? newMessages;
  List? tokenId;
  bool? connected;
  bool? notificationEnabled;
  bool? savingsAccount;
  bool? linkedToCnpj;
  Map? position;
  bool? online;

  Agent({
    this.agencyDigit,
    this.account,
    this.accountDigit,
    // this.digit,
    this.createdAt,
    this.avatar,
    this.fullname,
    this.username,
    this.birthday,
    this.cpf,
    this.rg,
    this.issuingAgency,
    this.gender,
    this.id,
    this.phone,
    this.status,
    this.newNotifications,
    this.newRatings,
    this.newMessages,
    this.tokenId,
    this.connected,
    this.bank,
    this.agency,
    // this.operation,
    this.savingsAccount,
    this.notificationEnabled,
    this.linkedToCnpj,
    // this.cep,
    // this.city,
    // this.state,
    this.country,
    // this.neighborhood,
    // this.address,
    // this.number,
    // this.addressComplement,
    // this.mainAddress,
    this.position,
    this.missionInProgress,
    this.online,
  });

  factory Agent.fromDoc(DocumentSnapshot doc) {
    print('Agent.fromDoc: ${doc.data()}');
    Agent agent = Agent();
    try {
      agent.createdAt = doc['created_at'];
      agent.avatar = doc['avatar'];
      agent.fullname = doc['fullname'];
      agent.username = doc['username'];
      agent.birthday = doc['birthday'];
      agent.cpf = doc['cpf'];
      agent.rg = doc['rg'];
      agent.issuingAgency = doc['issuing_agency'];
      agent.gender = doc['gender'];
      agent.id = doc['id'];
      agent.phone = doc['phone'];
      agent.status = doc['status'];
      agent.newNotifications = doc['new_notifications'];
      agent.newRatings = doc['new_ratings'];
      agent.newMessages = doc['new_messages'];
      agent.tokenId = doc['token_id'];
      agent.connected = doc['connected'];
      agent.bank = doc['bank'];
      agent.agency = doc['agency'];
      agent.savingsAccount = doc['savings_account'];
      agent.linkedToCnpj = doc['linked_to_cnpj'];
      agent.country = doc['country'];
      agent.notificationEnabled = doc['notification_enabled'];
      agent.position = doc['position'];
      agent.missionInProgress = doc['mission_in_progress'];
      agent.online = doc['online'];
      agent.account = doc['account'];
      agent.accountDigit = doc['account_digit'];
      agent.agencyDigit = doc['agency_digit'];
      
    } catch (e) {
      print('error');
      print(e);
    }
    return agent;
  }

  Map<String, dynamic> toJson(Agent? model) => model == null
      ? {
          'created_at': createdAt,
          'avatar': avatar,
          'fullname': fullname,
          'username': username,
          'birthday': birthday,
          'cpf': cpf,
          'rg': rg,
          'issuing_agency': issuingAgency,
          'gender': gender,
          'id': id,
          'phone': phone,
          'status': status,
          'new_notifications': newNotifications,
          'new_ratings': newRatings,
          'new_messages': newMessages,
          'token_id': tokenId,
          'connected': connected,
          'bank': bank,
          'agency': agency,
          // 'operation': operation,
          'savings_account': savingsAccount,
          'linked_to_cnpj': linkedToCnpj,
          // 'cep': cep,
          // 'city': city,
          // 'state': state,
          'country': country,
          // 'neighborhood': neighborhood,
          // 'address': address,
          // 'number': number,
          // 'address_complement': addressComplement,
          'notification_enabled': notificationEnabled,
          // 'digit': digit,
          // 'main_address': mainAddress,
          'position': position,
          "mission_in_progress": missionInProgress,
          "online": online,
          "account": account,
          "account_digit": accountDigit,
          "agency_digit": agencyDigit,
        }
      : {
          'created_at': model.createdAt,
          'avatar': model.avatar,
          'fullname': model.fullname,
          'username': model.username,
          'birthday': model.birthday,
          'cpf': model.cpf,
          'rg': model.rg,
          'issuing_agency': model.issuingAgency,
          'gender': model.gender,
          'id': model.id,
          'phone': model.phone,
          'status': model.status,
          'new_notifications': model.newNotifications,
          'new_ratings': model.newRatings,
          'new_messages': model.newMessages,
          'token_id': model.tokenId,
          'connected': model.connected,
          'bank': model.bank,
          'agency': model.agency,
          // 'operation': model.operation,
          'savings_account': model.savingsAccount,
          'linked_to_cnpj': model.linkedToCnpj,
          // 'cep': model.cep,
          // 'city': model.city,
          // 'state': model.state,
          'country': model.country,
          // 'neighborhood': model.neighborhood,
          // 'address': model.address,
          // 'number': model.number,
          // 'address_complement': model.addressComplement,
          'notification_enabled': model.notificationEnabled,
          // 'digit': model.digit,
          // 'main_address': model.mainAddress,
          'position': model.position,
          "mission_in_progress": model.missionInProgress,
          "online": model.online,
          "account": account,
          "account_digit": accountDigit,
          "agency_digit": agencyDigit,
        };
}
