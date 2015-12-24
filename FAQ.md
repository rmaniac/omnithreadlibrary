When creating a TOmniWorker (descendant) class is there a way to get this class back from the task in the OnTaskMessage event (other than passing the Self param in the message)?

(IOmniTask.Implementor)

My "problem" is that I want to send a both a pointer and an object to main,
I could of course do this with a record pointer or wrap it in a class but I
just don't really like that. Any ideas? (the pointer is set only once, on
task/thread creation and is never changed). The best thing I came up with is
introducing a Data property in the objectlist and storing the pointer there
but it's also ugly.
A pointer to a Node in a (Virtual)Tree (PVirtualNode). The way I designed it
I have a treeview where each connection to a machine (either local or
remote) is a node. Each node has a separate worker thread where session- and
process enumeration is done. This thread remains active and monitors session
events (eg a new session creation, a logoff etc) and notifies main of such
an event. If the user requests a refresh or has auto update activated the
worker thread is asked to enumerate and send data again.

(UserData)