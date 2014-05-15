library routing;

import "package:angular/angular.dart";

// Routing
void addressBookRouter(Router router, RouteViewFactory views) {
  views.configure({
    'add': ngRoute(
        path:'/add',
        view: 'partials/add.html'),
    'contact': ngRoute(
          path: '/contact/:id',
          // TODO based those two views on one single view parameterized, but is that cleaner ??
          mount: {
            'edit': ngRoute(
                path: '/edit',
                view: 'partials/edit.html'
            ),
            'view': ngRoute(
                path: '/view',
                view: 'partials/view.html'
            )
          }),
    'list': ngRoute(
        path: '/list',
        view: 'partials/list.html',
        defaultRoute : true)
  });
}