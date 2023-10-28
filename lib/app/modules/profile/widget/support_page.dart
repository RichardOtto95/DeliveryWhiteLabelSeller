import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:math' as math;

import '../profile_store.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends ModularState<SupportPage, ProfileStore> {
  final MainStore mainStore = Modular.get();
  final ScrollController scrollController = ScrollController();

  bool visibleSupport = true;

  @override
  void initState() {
    store.clearNewSupportMessages();

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          visibleSupport == false) {
        setState(() {
          visibleSupport = true;
        });
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          visibleSupport == true) {
        setState(() {
          visibleSupport = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: scrollController,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top + wXD(60, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    wXD(18, context),
                    wXD(8, context),
                    0,
                    wXD(0, context),
                  ),
                  child: Text(
                    "Como podemos ajudar?",
                    style: textFamily(
                      context,
                      fontSize: 16,
                      color: getColors(context).onSurface,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: wXD(362, context),
                    padding: EdgeInsets.symmetric(
                        horizontal: wXD(18, context),
                        vertical: wXD(18, context)),
                    margin: EdgeInsets.only(top: wXD(15, context)),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: getColors(context).primary.withOpacity(.4)),
                      color: getColors(context).surface,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: wXD(11, context)),
                          child: Text(
                            "Perguntas frequentes",
                            style: textFamily(
                              context,
                              fontSize: 15,
                              color: getColors(context).onBackground,
                            ),
                          ),
                        ),
                        Question(
                          title: "O que é o MercadoExpresso?",
                          answer:
                              "MercadoExpresso é uma plataforma na qual você pode distribuir seus produtos a clientes de sua região, em menos de 90 minutos e sem nenhum investimento.",
                        ),
                        Question(
                          title: "O que é um Fornecedor parceiro?",
                          answer:
                              "Fornecedor parceiro é um importador, fabricante, atacadista ou varejista que disponha de produtos à pronta entrega e queira utilizar a MercadoExpresso como um canal de vendas e distribuição adicional.",
                        ),
                        Question(
                          title: "Como ocorrem as vendas pela MercadoExpresso?",
                          answer:
                              """ 1 - Os clientes escolhem os produtos pelo aplicativo Android ou iOS MercadoExpresso;
 2 - Te notificamos quando entra um novo pedido;
 3 - Você aceita ou recusa a venda;
 4 - Caso aceite, um Agente parceiro vai no seu estabelecimento e coleta o pedido;
 5 - Toda semana você recebe o dinheiro de seus pedidos.
""",
                        ),
                        Question(
                          title: "Por que eu deveria estar na MercadoExpresso?",
                          answer:
                              """1 - Você vai dispor de um novo canal de vendas e distribuição sem se comprometer com qualquer investimento;
2 - Daremos a você as ferramentas para gerenciar seus produtos e os pontos de retirada dos mesmos e o ajudaremos a vender mais;
3 - Você descobrirá quais são os produtos mais solicitados e os que os cliente não estão encontrando e saberá como maximizar suas vendas.
4 - Com as incertezas deste momento que estamos passando, nunca se sabe quando os pontos de venda poderão ser fechados novamente. Com este canal de vendas e distribuição você conseguirá continuar operando mesmo em um novo cenário de lockdown.
""",
                        ),
                        Question(
                          title:
                              "uais os requisitos para ser um Fornecedor parceiro da MercadoExpresso?",
                          answer:
                              """1 - Tenha um ponto de retirada dentro de uma propriedade privada, que pode ser uma residência, loja, quiosque, armazém ou outro;
2 - Comprometa-se a manter o catálogo de produtos atualizado com fotos e preços, bem como a disponibilidade dos produtos para que o refuse-rate semanal (percentual de recusas de pedidos) se mantenha abaixo de 10%;
3 - Ter uma conta bancária em nome da empresa ou representante legal da empresa;
4 - Estar disposto a entregar um serviço de qualidade ao cliente;
5 - É obrigatório que a loja emita a Nota Fiscal e que a entregue para o Agente no momento da compra.
""",
                        ),
                        Question(
                          title: "Como é o processo de inscrição?",
                          answer:
                              """1 - Muito rápido: você pode se inscrever em minutos, sem contratos de longo prazo ou compromissos forçados. Preencha os seus dados, conte-nos sobre o seu negócio e porque deseja estar na MercadoExpresso;
2 - Analisaremos sua inscrição e verificaremos as informações que você nos enviar. Queremos ter certeza de que a MercadoExpresso oferece o serviço de que seu negócio precisa;
3 - Assim que sua inscrição for aprovada, seu acesso ao aplicativo do Fornecedor será liberado para que você possa configurar seu perfil, horário de funcionamento, catálogo de produtos, bem como acessar as ferramentas de gestão para liberar o acesso dos clientes e começar a aceitar pedidos;
""",
                        ),
                        Question(
                          title:
                              "Quanto custa para publicar meus anúncios e quanto tempo pode demorar para começar a vender?",
                          answer:
                              "O registro e a publicação de anúncios na MercadoExpresso são gratuitos. A única cobrança é a comissão de 15% sobre cada pedido feito. Uma vez que seu perfil, horários de funcionamento e catálogo de produtos tenham sido configurados, você só precisa fazer o check in para ficar online e notificar a plataforma que você está atendendo para começar a receber pedidos. É importantíssimo realizar o checkin e checkout corretamente em todos os expedientes para evitar que seu produto seja ofertado sem que você esteja atendendo, ou que você esteja aberto e seus anúncios não estejam visíveis para os clientes. Apenas os anúncios de fornecedores que estejam online ficam visíveis para os clientes.",
                        ),
                        Question(
                          title:
                              "Como e quando recebo o pagamento pelas minhas vendas?",
                          answer:
                              """Após aceitar a solicitação de compra de um cliente, prepare com agilidade e organização os itens do pedido para que a entrega ao cliente possa ocorrer com segurança dentro de até 90 minutos. Se for possível, teste os itens e verifique se não há nenhum vício ou defeito de fabricação antes de preparar a encomenda para Despacho. Com o aplicativo do Fornecedor, gere evidências dos testes e dos itens que serão enviados através de fotografias. Ex: cabos, componentes, etc. Se for possível lacre o produto apropriadamente e também registre evidências disso no aplicativo. Com tudo pronto, confirme que o aplicativo está pronto para despacho para que um Agente seja destacado para retirar o pedido. 

Quando o Agente se apresentar para você, valide através da fotografia em seu aplicativo se trata-se da mesma pessoa. Em seguida, solicite o token de verificação dele para confirmar a sua autorização para retirar o pedido. Apenas entregue o pedido ao Agente se o aplicativo informar que o token é válido. Após validar o token, o status do pedido é automaticamente atualizado para Despachado. 
""",
                        ),
                        Question(
                          title:
                              "Preciso entrar em contato com a MercadoExpresso, como proceder?",
                          answer:
                              "Fale com a gente enviando uma mensagem pelo suporte do aplicativo ou através do email suporte@mercadoexpresso.com.br.",
                        ),
                        Question(
                          title:
                              "Não posso despachar um Pedido que confirmei. E agora?",
                          answer:
                              "Um dos diferenciais da MercadoExpresso está no fato de apresentarmos todas as informações sobre os pedidos ao enviar as solicitação para os nossos parceiros. Por isso, só aceite as entregas que você realmente puder atender. O cancelamento de um Pedido é feito apenas em situações emergenciais. Caso tenha alguma dúvida, fale com a gente pelo suporte do aplicativo ou através do email suporte@mercadoexpresso.com.br.",
                        ),
                        Question(
                          title:
                              "Caso o Agente não compareça ou não disponha de um token válido, o que fazer?",
                          answer:
                              "Entre em contato conosco pelo suporte do aplicativo ou através do email suporte@mercadoexpresso.com.br",
                        ),
                        Question(
                          title: "Caso o Agente devolva o Pedido, o que fazer?",
                          answer:
                              """Em algumas situações, o Agente não conseguirá realizar a entrega - por exemplo, quando o destinatário está ausente, dentro outras variáveis. Caso isso ocorra, o Agente poderá ser instruído para devolver o Pedido no ponto de Coleta. 

Solicitamos que neste caso, fale conosco pelo suporte e registre a devolução, bem como valide se a encomenda não foi violada, evidenciando tudo no chat do suporte.
""",
                        ),
                        Question(
                          title: """Token inválido, agente não apareceu...

Qual é a cobertura de entrega?
""",
                          answer: "Em breve",
                        ),
                        Question(
                          title:
                              "Quais são meus direitos como Fornecedor parceiro?",
                          answer:
                              "É importante que você leia nossos Termos e Condições. Lá você encontrará informações importantes sobre seus direitos, responsabilidades, detalhes sobre repasses, dentre outras coisas importantes.",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
            right: visibleSupport ? wXD(16, context) : wXD(-60, context),
            bottom: wXD(100, context),
            child: GestureDetector(
              onTap: () {
                print('onTap');
                Modular.to.pushNamed('/profile/support-chat');
              },
              child: Container(
                height: wXD(56, context),
                width: wXD(56, context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getColors(context).surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      offset: Offset(0, 3),
                      color: getColors(context).onBackground.withOpacity(.15),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.support_agent,
                  color: getColors(context).onBackground,
                  size: wXD(35, context),
                ),
              ),
            ),
          ),
          DefaultAppBar("Suporte"),
        ],
      ),
    );
  }
}

class Question extends StatefulWidget {
  final String title;
  final String answer;
  const Question({Key? key, required this.title, required this.answer})
      : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => visible = !visible),
          child: Container(
            alignment: Alignment.bottomCenter,
            // height: wXD(20, context),
            child: Column(
              children: [
                SizedBox(height: wXD(7, context)),
                Row(
                  children: [
                    Container(
                      width: wXD(305, context),
                      child: Text(
                        widget.title,
                        style: textFamily(
                          context,
                          fontSize: 12,
                          color: getColors(context).onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    Transform.rotate(
                      angle: visible ? math.pi / -2 : math.pi / 2,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: wXD(15, context),
                        color: getColors(context).primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: wXD(7, context)),
              ],
            ),
          ),
        ),
        Visibility(
          visible: visible,
          child: Container(
            child: Text(
              widget.answer,
              style: textFamily(
                context,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: getColors(context).onBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
