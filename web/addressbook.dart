import 'package:angular/application_factory.dart';
import 'package:angular/angular.dart';
import 'dart:html' as dom;

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

// Routing
void addressBookRouter(Router router, RouteViewFactory views) {
  views.configure({
    'add': ngRoute(
        path:'/add',
        view: 'partials/contactAdd.html'),
    'contact': ngRoute(
          path: '/contact/:id',
          // TODO based those two views on one single view parameterized, but is that cleaner ??
          mount: {
            'edit': ngRoute(
                path: '/edit',
                view: 'partials/contactEdit.html'
            ),
            'view': ngRoute(
                path: '/view',
                view: 'partials/contactView.html'
            )
          }),
    'list': ngRoute(
        path: '/list',
        view: 'partials/contactList.html',
        defaultRoute : true)
  });
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

/**
 * The controller which takes the data to display from the service and make them
 * available to the view
 */
/*
 * The controller annotation has been removed and should be replaced with component
 * if I truly understand the story ... weird come back later on it.
 * @TODO check that story of deprecated controller
 */
@Controller(
    selector: '[contact-list]',
    publishAs: 'contactList'
)
class ContactList {
  List contacts;
  String search = "";
  ContactService contactService;

  ContactList(this.contactService) {
    contacts = contactService.contacts;
  }

  bool doSearch(Contact contact) {
    return contact.firstName.toLowerCase().contains(search.toLowerCase()) ||
        contact.lastName.toLowerCase().contains(search.toLowerCase());
  }
}


/**
 * Here we are defining an abstract controller which could be shared
 * accross many controllers to demonstrate that we can easily
 * construct a class based inheritance also for controllers.
 */
class AbstractContactCtrl {
  Contact contact;
  ContactService contactService;
  RouteProvider routeProvider;

  AbstractContactCtrl(this.contactService, this.routeProvider) {
    contact = contactService.findById(routeProvider.parameters['id']);
  }

}

@Controller(
    selector: '[contact-edit]',
    publishAs: 'contactEdit'
)
class ContactEdit extends AbstractContactCtrl {
  ContactEdit(ContactService contactService, RouteProvider routeProvider) : super(contactService, routeProvider);

  void update() {
    contactService.update(contact);
  }
}

@Controller(
    selector: '[contact-add]',
    publishAs: 'contactAdd'
)
class ContactAdd {
  Contact contact = new Contact(null, "","","","");
  ContactService _contactService;

  ContactAdd(this._contactService);

  void save() {
    _contactService.add(contact);
  }
}

/*
 *  Here we can see that the filter has finally been renamed to formatted.
 *  This is in my opinion an awesome idea because it is now an understable term.
 *
 *  The term filter had two problems :
 *    - A filter formatter existed an people were lost easily when starting developping with angular
 *    - People expects a filter to purge a list of data to keep only right elements. This was not the case
 *    with the previous filter because the aim was to alter the value of a binding for displaying purpose => formatter term.
 */
@Formatter(name: "doSearch")
class SearchFilter {
  List<Contact> call(List<Contact> contacts, String search) {
    if (search == null) {
      return contacts;
    }
    return contacts.where(
        (Contact c) => (
            c.firstName.toLowerCase().contains(search.toLowerCase()) ||
            c.lastName.toLowerCase().contains(search.toLowerCase()))
        ).toList();
  }
}

// WARNING here we do not have anymore the translation camelCase => camel-case
@Decorator(selector: '[enter-view]')
class EnterView {
  dom.Element _elmt;

  EnterView(this._elmt) {
    _elmt.onClick.listen((event) => print('clicked'));
  }

}

/**
 * A VCard component which takes as entry a contact and display it in a standardized way.
 */
@Component(
    selector: 'vcard',
    templateUrl: 'partials/vcard/vcard_component.html',
    cssUrl: 'partials/vcard/vcard_component.css',
    publishAs: 'vcard'
)
class VCard {

  // The NgTwoWay annotation is deprecated but the replacement is
  // not yet implemented so we need to use this annotation
  @NgTwoWay('contact')
  Contact contact;

}

/**
 * The service which allows to access the contact.
 */
@Injectable()
class ContactService {
  // Here we are declaring the list of contacts as private because we want to ensure that no one is going to be accessed directly
  List<Contact> _contacts = [ new Contact(0, "Wayne", "Bruce", "Gotham city","555-BATMAN" ),
                              new Contact(1, "Parker", "Peter", "New York","555-SPDRMN" ),
                              new Contact(2, "Storm", "Jane", "Baxter building, New York","555-INVGRL" ),
                              new Contact(3, "Richards", "Red", "Baxter building, New York","555-MRFANT" ),
                              new Contact(4, "Storm", "Johnny", "Baxter building, New York","555-TORCH" ),
                              new Contact(5, "Grimm", "Benjamin", "Baxter building, New York","555-THING" ),
                              new Contact(6, "Murdock", "Matt", "San Francisco","555-DARDVL" ),
                              new Contact(7, "Stark", "Tony", "Stark tower, New York","555-IRNMAN" )];

  List<Contact> get contacts => _contacts;

  Contact findById(String id) => _contacts.where((Contact c) => c.id == int.parse(id)).first;

  int add(Contact c) {
    c.id = _contacts.length;
    _contacts.add(c);
    return c.id;
  }

  void update(Contact c) {
    Contact inDB = contacts.where((Contact it) => c.id == it.id).single;
    inDB.firstName = c.firstName;
    inDB.lastName = c.lastName;
    inDB.phone = c.phone;
    inDB.address = c.address;
  }
}

/**
 * A contact class because AngularDart allows us to map the view with classes and not only json objects.
 */
class Contact {
  int id;
  String firstName;
  String lastName;
  String address;
  String phone;

  Contact(this.id, this.lastName, this.firstName, this.address, this.phone);
}

