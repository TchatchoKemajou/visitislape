import 'dart:io';
import 'package:visitislape/api/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<String> generate(List<dynamic> invoice, info, name) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(info),
        SizedBox(height:PdfPageFormat.cm),
        buildTitle(),
        SizedBox(height:PdfPageFormat.cm),
        buildInvoice(invoice),
        SizedBox(height:PdfPageFormat.cm),
        //Divider(),
        buildTotal(),
      ],
      footer: (context) => buildFooter(),
    ));
    PdfApi.saveDocument(name: name + '.pdf', pdf: pdf);

    return "success";
  }

  static Widget buildHeader(info) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: info['number'],
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(),
              buildInvoiceInfo(info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Digital Security", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Digital Security, Douala, Yassa"),
        ],
      );

  static Widget buildInvoiceInfo(info) {
//    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Numero de fiche:',
      'Date de sortie:',
    ];
    final data = <String>[
      info['number'],
      info['date'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ISLAPE", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text("institut supérieur la perle, Douala, Yassa"),
        ],
      );

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fiche de police',
            textAlign: pw.TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildInvoice(List<dynamic> invoice) {
    final headers = [
      'Numero',
      'Nom',
      "Heure d'entrée",
      'Heure de sortie',
      'Raison',
      'Gardien'
    ];
    final data = invoice.map((item) {
      ///final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item['visitId'],
        item['visitorId']['visitorFullName'],
        item['visitTimeStar'],
        item['visiTimeEnd'],
        item['visitHost'],
        item['guardID']['guardFullName'],
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const pw.TableBorder(
        right: pw.BorderSide(
          width: 2
        ),
        left: pw.BorderSide(
            width: 2
        ),
        top: pw.BorderSide(
            width: 2
        ),
        bottom: pw.BorderSide(
            width: 2
        ),
        horizontalInside: pw.BorderSide(
            width: 2
        ),
        verticalInside: pw.BorderSide(
            width: 2
        ),
      ),
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
      },
    );
  }

  static Widget buildTotal() {
    // final netTotal = invoice.items
    //     .map((item) => item.unitPrice * item.quantity)
    //     .reduce((item1, item2) => item1 + item2);
    // final vatPercent = invoice.items.first.vat;
    // final vat = netTotal * vatPercent;
    // final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total de visite',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: "15",
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: '', value: "Certifier par digital security"),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
