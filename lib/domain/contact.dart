part of domains;

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
