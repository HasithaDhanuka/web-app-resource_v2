

# web_app
//      flutter run -d chrome --web-renderer html      
//      flutter run -d chrome --web-renderer html --profile
//      flutter build web --release --web-renderer html

# Web_canverskit
//      flutter run -d chrome --web-renderer canvaskit
//      flutter build web --web-renderer canvaskit --release
//      flutter build web --web-renderer canvaskit
//       <base href="/shop_owner/">


dart run flutter_native_splash:create
https://github.com/HasithaDhanuka/shop_owner.git



gs://matsuyama-web.appspot.com
Create a new repository on GitHub.
On your local machine, navigate to the directory containing your project.
Run git init to initialize a new Git repository.
Run git add . to add all files to the repository.
Run git commit -m "Initial commit" to commit the changes.
Run git remote add origin <remote repository URL> to add a remote repository.
Run git push -u origin master to push the changes to the remote repository.







The following assertion was thrown during a scheduler callback:
Looking up a deactivated widget's ancestor is unsafe.
At this point the state of the widget's element tree is no longer stable.
To safely refer to a widget's ancestor in its dispose() method, save a reference to the ancestor by
calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method.