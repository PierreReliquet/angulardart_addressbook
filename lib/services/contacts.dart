part of service;

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

