part of formatters;

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
