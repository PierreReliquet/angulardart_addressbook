part of decorators;

// WARNING here we do not have anymore the translation camelCase => camel-case
@Decorator(selector: '[enter-view]')
class EnterView {
  dom.Element _elmt;

  EnterView(this._elmt) {
   _elmt.onClick.listen((event) => print('clicked'));
  }

}