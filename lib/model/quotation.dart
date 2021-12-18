// import 'package:cotizapack/model/product.dart';
// class QuotationsList{
//   QuotationsList({
//     this.quotations
//   });
//   List<QuotationModel>? quotations;

//     factory QuotationsList.fromJson(List<dynamic> parsedJson) {

//     List<QuotationModel> quotations = parsedJson.map((i)=>QuotationModel.fromJson(i)).toList();

//     return new QuotationsList(
//       quotations: quotations,
//     );
//   }
// }

// class QuotationModel{
//     QuotationModel({
//         this.id,
//         this.title,
//         this.description,
//         this.expirationDate,
//         this.subTotal,
//         this.total,
//         this.userId,
//         this.collection,
//         this.email,
//         this.product,
//         this.clientID,
//         this.quantity,
//         this.createAt,
//         this.clientName,
//         this.status
//     });

//     String? id;
//     String? collection;
//     String? title = '';
//     String? description = '';
//     int? quantity;
//     ///estos son datos de lista
//     ProductModel? product;
//     int? expirationDate;
//     double? subTotal;
//     double? total;
//     ///
//     String? userId;
//     String? email;
//     String? clientName;
//     String? clientID;
//     int? createAt;
//     int? status;

//     factory QuotationModel.fromJson(Map<String, dynamic> json) => QuotationModel(
//         id: json["\u0024id"],
//         collection: json["collection"],
//         title: json["title"],
//         description: json["description"],
//         quantity: json['quantity'],
//         expirationDate: json["expirationDate"],
//         subTotal: json["subTotal"].toDouble(),
//         total: json['total'].toDouble(),
//         userId: json["userID"].toString(),
//         email: json["email"],
//         product:  json["product"] != null ? ProductModel.fromJson(json["product"]) : null,
//         clientID: json["clientID"],
//         createAt: json["create_at"],
//         clientName: json["clientName"],
//         status: json["status"]
//     );

//     Map<String, dynamic> toJson() => {
//       "\u0024id": id,
//       "title": title,
//       "description": description,
//       "quantity": quantity,
//       "expirationDate": expirationDate,
//       "subTotal": subTotal,
//       "total": total,
//       "userID": userId,
//       "email": email,
//       "product": product == null ? product!.toJson() : null,
//       "clientID": clientID,
//       "clientName": clientName,
//       "create_at": createAt,
//       "status": status
//     };
// }
