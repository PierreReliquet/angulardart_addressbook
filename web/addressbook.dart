import 'package:angular/application_factory.dart';
import 'package:angular/angular.dart';

import "package:angulardart_addressbook/components.dart";
import "package:angulardart_addressbook/controllers.dart";
import "package:angulardart_addressbook/decorators.dart";
import "package:angulardart_addressbook/formatters.dart";
import "package:angulardart_addressbook/routing.dart";
import "package:angulardart_addressbook/services.dart";

//TODO split that file into many smaller

void main() {
  applicationFactory()
      // Here we are just declaring an inline module using the .. notation which gonna contains all the services
      ..addModule(new Module()..bind(ContactService))
      // And finally our address book module
      ..addModule(new AddressBook())
      ..run();
      // Module declaration order does not matter
}


/**
 * The address book module contains the controllers, formatter and components.
 *
 * IMHO at least the components should be in another library with the Contact class
 * to provide reusable components
 */
class AddressBook extends Module {
  AddressBook() {
    bind(ContactList);
    bind(ContactEdit);
    bind(ContactAdd);
    bind(SearchFilter);
    bind(EnterView);
    bind(VCard);
    bind(RouteInitializerFn, toValue: addressBookRouter);
    // At the beginning the service was in here but it has been removed to
    // show how to use other existing modules
    //bind(ContactService);

    // Required otherwise angulardart does not know how to interprete the route
    bind(NgRoutingUsePushState, toFactory: (_) => new NgRoutingUsePushState.value(false));
  }
}

