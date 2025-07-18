The gitlab instance is modified to include a postfix email forwarder.

After initial creation the container takes a few mins to start up as 
it does a bunch of setup.

The initial login is `root` with a password generated on the first - 
of the container.  The password can be found in the file:

```
config/initial_root_password
```
```


