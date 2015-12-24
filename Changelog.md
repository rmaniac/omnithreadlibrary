# 3.0: 2011-12-30 #
  * New features
    * Support for 64-bit platform. Great thanks to [GJ](GJ.md) for doing most of the work!
    * Implemented background worker abstraction, Parallel.BackgroundWorker.
    * Implemented `Atomic<T>` class for lock-free initialization of interfaces and objects.
    * Implemented `Locked<T>` class for locking intialization of practically anything.
> > > http://www.thedelphigeek.com/2011/11/atomic-interface-initialization.html


> http://www.thedelphigeek.com/2011/11/per-object-locking.html

> http://www.thedelphigeek.com/2011/12/on-optimistic-and-pessimistic.html

> http://www.thedelphigeek.com/2011/12/creating-object-from-unconstrained.html
  * TOmniValue.AsInteger, AsString and AsWideString now work if the TOmniValue contains a Variant of the apropriate type.
  * TOmniValue can store arrays, hashes and records. Variant arrays are no longer used. IsArray tests it TOmniValue contains an array and AsArray returns this internal container. Default indexed property still accesses individual elements in this container. See demo 50\_OmniValueArray for an example.
> > http://www.thedelphigeek.com/2011/11/tomnivalue-handles-arrays-hashes-and.html
  * Added a class which can wrap any record - `TOmniRecordWrapper<T>`.
  * Added an interface which can wrap any object and destroy it when the interface goes out of scope - IOmniAutoDestroyObject.
  * Bug fixes
    * Fixed bugs in TOmniInterfaceDictionary which caused scheduled tasks not to be destroyed until the program was terminated. Great thanks to [Zarko](Zarko.md) for providing a reproducible test case.
    * Fixed race condition between TOmniTask.Execute and TOmniTask.Terminate.
    * Under some circumstances ProcessMessage failed to rebuild handle array before waiting which could cause 'invalid handle' error.
    * Fixed wrong order in teardown sequence in TOmniTask.Execute which could cause access violation crash. Great thanks to [Alisov](Anton.md) for providing a reproducible test case.
    * Fixed invalid "A call to an OS function failed" error in DispatchEvent.
    * TOmniMessageQueue.Enqueue leaked if queue was full and value contained reference counted value (found by [meishier](meishier.md)).
    * Number of producers/consumers in `TOmniForkJoin<T>.StartWorkerTasks` was off by 1 (found by [meishier](meishier.md)).
  * New demos
    * 49\_FramedWorkers: Multiple frames communication with each own worker task.
    * 50\_OmniValueArray: Wrapping arrays, hashes and records in TOmniValue.
    * 51\_PipelineStressTest: Stress test by [Alisov](Anton.md).
    * 52\_BackgrondWorker: Demo for the new Parallel.BackgroundWorker abstraction.

# 2.2: 2011-10-11 #
  * New features
    * Delphi XE2 support (Windows 32-bit only).
    * Parallel.Task can be used to execute multiple copies of a common code.
> > > http://www.thedelphigeek.com/2011/09/life-after-21-parallel-data-production.html
    * Breaking change! Parallel.Join reimplemented as IOmniParallelJoin interface to add exception and cancellation support. User code must call .Execute on the interface returned from the Parallel.Join to start the execution.
> > > http://www.thedelphigeek.com/2011/07/life-after-21-paralleljoins-new-clothes.html
    * Added exception handling to Parallel.Join. Tasks' fatal exceptions are wrapped in EJoinException and raised at the end of Parallel.Join method (or when WaitFor is called if Join is executed with the .NoWait modifier).
    * Added exception handling to `IOmniFuture<T>`. Tasks' fatal exception is raised in .Value. New function .FatalException and .DetachException.
> > > http://www.thedelphigeek.com/2011/07/life-after-21-exceptions-in.html
    * Two version of Parallel.Async (the ones with explicit termination handlers) were removed as this functionality can be achieved by using Parallel.TaskConfig.OnTerminated.
> > > http://www.thedelphigeek.com/2011/07/life-after-21-async-redux.html
    * Parallel.Join(const task: TOmniTaskDelegate) is no longer supported. It was replaced with the Parallel.Join(const task: IOmniJoinState).
    * Parallel.Join no longer supports taskConfig parameter (replaced by the IOmniParallelJoin.TaskConfig function).
    * Number of simultaneously executed task in Parallel.Join may be set by calling the new IOmniParallelJoin.NumTasks function.
    * Implemented TOmni[Base](Base.md)Queue.IsEmpty. Keep in mind that the returned value may not be valid for any amount of time if other threads are reading from/writing to the queue.
    * Implemented another IOmniTaskControl.OnTerminated overload acception parameterless anonymous function.
    * Implemented [I|T]OmniBlockingCollection.IsFinalized.
    * Parallel.Pipeline accepts 'simple stage' (for loop implemented internally).
> > > http://www.thedelphigeek.com/2011/09/life-after-21-pimp-my-pipeline.html
    * TOmniValue can natively store exception objects (AsException, IsException).
    * Implemented IOmniBlockingCollection.ReraiseExceptions. If enabled (default: disabled), [Try](Try.md)Take will check if returned value for exception (TOmniValue.IsException) and if true, it will reraise this exception instead of returning a result.
    * Assertions are enabled in OTLOptions.inc - OtlContainers needs them.
  * Bug fixes
    * Event monitor in connection to the thread pool was totally broken. (Big thanks to [alisov](anton.md) for finding the problem.)
    * Fixed [Try](Try.md)Add/CompleteAdding/[Try](Try.md)Take three-thread race condition in TOmniBlockingCollection.
> > > http://www.thedelphigeek.com/2011/08/multithreading-is-hard.html
  * New demos
    * 48\_OtlParallelExceptions: Exception handling in high-level OTL constructs.

# 2.1: 2011-07-19 #
  * New features
    * Parallel.Async can be used to start simple background tasks.
> > > http://www.thedelphigeek.com/2011/04/simple-background-tasks-with.html
    * Parallel.ForkJoin - divide and conquer (fork/join) framework.
> > > http://www.thedelphigeek.com/2011/05/divide-and-conquer-in-parallel.html
    * OtlParallel tasks can be configured with Parallel.TaskConfig; you can also use it to communicated with the owner thread from the task.
> > > http://www.thedelphigeek.com/2011/04/configuring-background-otlparallel.html
    * IOmniTask[Control](Control.md) can call Invoke method to asynchronously execute a block of code in the other thread.
> > > http://www.thedelphigeek.com/2011/03/synchronize-comes-to-omnithreadlibrary.html
    * Passes timer ID to timer proc if it accepts const TOmniValue parameter.
    * Support for non-silent exceptions removed.
    * Added property IOmniTaskControl.FatalExecption containing exception that was caught at the task level.
    * Change signature for exception filters in OtlHook.FilterException.
    * IOmniTaskControl termination empties task message queue and calls appropriate OnMessage handlers.
  * Bug fixes
    * Fixed race condition in TOmniTask.Execute.
    * OtlParallel compiles in Delphi 2009.
    * OTL monitor message window could be used after it was destroyed.
    * Parallel.ForEach was never running on more than Process.Affinity.Count tasks.
    * OtlParallel pools are created on the fly - OtlParallel unit can be used from a DLL.
    * [dottor\_jeckill](dottor_jeckill.md) Bug fix: TOmniResourceCount.TryAllocate always returned False.
    * Enumerating over TOmniTaskControlList (for example when using IOmniTaskGroup.SendToAll) leaked one object.
    * Makes sure timers are called even if there's a constant stream of messages in registered message queues.
    * Fixed exception handling in the thread pool.
  * New demos
    * 43\_InvokeAnonymous: Demo for IOmniTaskControl.Invoke and IOmniTask.Invoke.
    * 44\_Fork-Join QuickSort: QuickSort implemented with Parallel.ForkJoin.
    * 45\_Fork-Join max: Selecting maximum element in an array using Parallel.ForkJoin.
    * 46\_Async: Demo for Parallel.Async.
    * 47\_TaskConfig: Demo for Parallel.TaskConfig.

# 2.0: 2010-12-10 #
  * New high-level primitives (unit OtlParallel):
    * Improved parallel for (Parallel.ForEach).
> > > http://www.thedelphigeek.com/2010/06/omnithreadlibrary-20-sneak-preview-1.html
    * Futures (`Parallel.Future<T>`).
> > > http://www.thedelphigeek.com/2010/06/future-of-delphi.html
    * Pipelines (Parallel.Pipeline).
> > > http://www.thedelphigeek.com/2010/11/multistage-processes-with.html
  * Added support for multiple simultaneous timers. SetTimer takes additional 'timerID' parameter. The old SetTimer assumes timerID = 0.
  * IOmniTask/IOmniTaskControl:
    * ParamByName has been removed, use .Param[name: string].
    * Param returns TOmniValueContainter.
  * IOmniTaskControl.OnMessage also accepts an object (message dispatcher).
  * TOmniValueContainer
    * IndexOfName renamed to TOmniValueContainer.IndexOf.
    * New methods in TOmniValueContainer class: ByName, Count, Exists.
    * New properties: Items[integer](integer.md), Items[string](string.md) and Items[TOmniValue](TOmniValue.md).
  * TOmniValue
    * Fixed memory leak when sending String, WideString, Variant and Extended values over the communication channel and when queueing them into TOmni[Base](Base.md)Queue.
    * Implemented _AddRef,_Release, _ReleaseAndClear.
    * TOmniValue can be cast as Int64.
    * Implemented conversions to/from TValue (Delphi 2010 and newer).
    * Implemented constructor.
    * [scarre](scarre.md) Added TDateTime support.
  * New classes and interfaces
    * TOmniMessageQueueTee
    * IOmniCommDispatchingObserver
    * TOmniCounter, auto-initialized wrapper around the IOmniCounter
    * TOmniMessageID record, used internally to implement timers.
  * TOmniThreadPool: ThreadDataFactory can now accept either a function or a method (but can be used only as a method - SetThreadDataFactory).
  * TOmniEventMonitor: Message retrieving loop destroys interface immediately, not when the next message is received.
  * TOmniTaskFunction renamed to TOmniTaskDelegate.
  * Added function CreateResourceCount(initialCount): IOmniResourceCount.
  * Renamed IOmniCancellationToken.IsSignaled -> IsSignalled.
  * .dproj tests renamed to .2007.dproj.
  * Added Delphi XE project files.
  * Bugs fixed:
    * Thread pool was immediately closing unused threads if MaxExecuting was set to -1.
    * Ugly bugs in TOmniBlockingCollection removed.
  * New demos
    * 38\_OrderedFor: Ordered parallel for loops.
    * 39\_Future: Futures.
    * 40\_Mandelbrot: Parallel graphics demo (very simple).
    * 41\_Pipeline: Pipelines.
    * 42\_MessageQueue: Stress tests for TOmniMessageQueue._

# 1.05a: 2010-03-08 #
  * Bug fixed: TOmniTaskControl.OnMessage(eventHandler: TOmniTaskMessageEvent) was broken.
  * Bug fixed: TOmniTaskControl.OnMessage/OnTerminate uses event monitor created in the context of the task controller thread (was using global event monitor created in the main thread).
  * Implemented TOmniEventMonitorPool, per-thread TOmniEventMonitor allocator.

# 1.05: 2010-02-25 #
  * Big rename: TOmniBaseStack -> TOmniBaseBoundedStack, TOmniStack -> TOmniBoundedStack, TOmniBaseQueue -> TOmniBaseBoundedQueue, TOmniQueue -> TOmniBoundedQueue, IInterfaceDictionary -> IOmniInterfaceDictionary, IInterfaceDictionaryEnumerator -> IOmniInterfaceDictionaryEnumerator, TInterfaceDictionaryPair -> TOmniInterfaceDictionaryPair.
  * Implemented dynamically allocated, O(1) enqueue and dequeue, threadsafe, microlocking queue. Class TOmniBaseQueue contains base implementation while TOmniQueue adds notification support.
  * Implemented resource counter with empty state signalling TOmniResourceCount.
  * New unit OtlCollection which contains blocking collection implementation TOmniBlockingCollection.
  * IOmniTask implements Implementor property which points back to the worker instance (but only if worker is TOmniWorker-based).
  * Implemented IOmniEnvironment interface and function Environment returning some information on system, process and thread.
  * Implemented IOmniTaskControl.UserData[.md](.md). The application can store any values in this array. It can be accessed via the integer or string index.
  * Implemented TOmniValue.IsInteger.
  * Implemented IOmniCancellationToken, used in Parallel infrastructure and in IOmniTaskControl.TerminateWhen.
  * IOmniTaskControl and IOmniTask implement CancellationToken: IOmniCancellationToken property which can be used by the task and task controller.
  * IOmniTaskControl implements OnMessage(msgID, handler).
  * Implemented Parallel.ForEach wrapper (Delphi 2009 and newer).
  * Implemented Parallel.Join wrapper (Delphi 2009 and newer).
  * Refactored and enhanced TOmniValueContainer.
  * TOmniTaskFunction now takes 'const' parameter.
  * Bugs fixed:
    * TOmniEventMonitor.OnTaskUndeliveredMessage was missing 'message' parameter.
    * Set package names and designtime/runtime type in D2009/D2010 packages.
  * New demos:
    * 32\_Queue: Stress test for new TOmniBaseQueue and TOmniQueue.
    * 33\_BlockingCollection: Stress test for new TOmniBlockingCollection, also demoes the use of Environment to set process affinity.
    * 34\_TreeScan: Parallel tree scan using TOmniBlockingCollection.
    * 35\_ParallelFor: Parallel tree scan using Parallel.ForEach (Delphi 2009 and newer).
    * 36\_ParallelAggregate: Parallel calculations using Parallel.ForEach.Aggregate (Delphi 2009 and newer).
    * 37\_ParallelJoin: Parallel.Join demo.

# 1.04b: 2009-12-18 #
  * ahwux, gabr Fixed Delphi 2010 Update 4 compatibility.
  * ahwux Added missing task interface cleanup to OnTerminated in demo 18.

# 1.04a: 2009-12-13 #
  * **IMPORTANT**: Fixed thread pool exception handling.
  * Implemented IOmniTask.RegisterWaitObject/UnregisterWaitObject.
  * Added demo 31\_WaitableObjects: Demo for the new RegisterWaitObject/UnregisterWaitObject API.
  * Current versions of 3rd party units included.

# 1.04: 2009-11-23 #
  * **COMPATIBILITY ISSUES**
    * Changed semantics in comm event notifications! When you get the 'new message' event, read all messages from the queue in a loop!
    * Message is passed to the TOmniEventMonitor.OnTaskMessage handler. There's no need to read from Comm queue in the handler.
    * Exceptions in tasks are now visible by default. To hide them, use IOmniTaskControl.SilentExceptions. Test 13\_Exceptions was improved to demonstrate this behaviour.
  * Works with Delphi 2010.
  * Default communication queue size reduced to 1000 messages.
  * Support for 'wait and send' in IOmniCommunicationEndpoint.SendWait.
  * Communication subsystem implements observer pattern.
  * WideStrings can be send over the communication channel.
  * New event TOmniEventMonitor.OnTaskUndeliveredMessage is called after the task is terminated for all messages still waiting in the message queue.
  * Implemented automatic event monitor with methods IOmniTaskControl.OnMessage and OnTerminated. Both support 'procedure of object' and 'reference to procedure' parameters.
  * Implemented IOmniTaskControl.Unobserved behaviour modifier.
  * New unit OtlSync contains (old) TOmniCS and IOmniCriticalSection together with (new)  TOmniMREW - very simple and extremely fast multi-reader-exclusive-writer - and atomic CompareAndSwap functions.
  * New unit OtlHooks contains API that can be used by external libraries to hook into OTL thread creation/destruction process and into exception chain.
  * All known bugs fixed.
  * Current versions of 3rd party units included.
  * New demos:
    * 25\_WaitableComm: Demo for ReceiveWait and SendWait.
    * 26\_MultiEventMonitor: How to run multiple event monitors in parallel.
    * 27\_RecursiveTree: Parallel tree processing.
    * 28\_Hooks: Demo for the new hook system.
    * 29\_ImplicitEventMonitor: Demo for OnMessage and OnTerminated, named method approach.
    * 30\_AnonymousEventMonitor: Demo for OnMessage and OnTerminated, anonymous method approach.

# 1.03: 2009-02-08 #
  * Added support for per-thread initialized data to the thread pool.
  * Communication between TOmniThreadPool and TOTPWorker is protected with a critical section. That allows multiple threads to Schedule tasks into one thread pool.
  * Removed OnWorkerThreadCreated\_Asy/OnWorkerThreadDestroyed\_Asy thread pool notification mechanism which was pretty much useless.
  * Added connection pool demo.

# 1.02: 2009-02-01 #
  * Thread pool reimplemented using OmniThreadLibrary.
  * Implemented IOmniTaskControl/IOmniTask.Enforced behaviour modifier.
  * Implemented IOmniTaskControlList, a list of IOmniTaskControl interfaces.
  * Added background file search demo.
  * Implemented TOmniCS critical section wrapper.
  * Fixed a bug in TGpStringTable.Grow and TGpStringDictionary.Grow which caused random memory overwrites.
  * Bug fixed: One overload of SetParameter was not returning Self.
  * [Jamie](Jamie.md) Fixed bug in TOmniTaskExecutor.Asy\_SetTimerInt.
  * [ajasja](ajasja.md) Fixed bug in demos 4, 5, and 6. Exceptions was raised if demo app was closed without stopping the background task first.
  * Updated to FastMM 4.90.
  * Current versions of 3rd party units included.

# 1.01: 2008-11-01 #
  * [GJ](GJ.md) Redesigned stack cotainer with better lock contention.
  * [GJ](GJ.md) Totally redesigned queue container, which is no longer based on stack and allows multiple reader.
  * Full D2009 support; D2009 packages, project files and Tests project group.
  * Invoke-by-name and invoke-by-address messaging implemented (http://17slon.com/blogs/gabr/2008/10/erlangenizing-omnithreadlibrary.html and http://17slon.com/blogs/gabr/2008/10/omnithreadlibrary-using-rtti-to-call.html and demos 18 and 19).
  * CreateTask(reference to function (task: ITaskControl)) implemented (D2009 only).
  * Blocking wait (ReceiveWait) implemented (demo 19).
  * Added enumerator to the IOmniTaskGroup interface.
  * Implemented IOmniTaskGroup.RegisterAllWithTask and .UnregisterAllFromTask.
  * Added automatic comm unregistration for IOmniTaskGroup.RegisterAllCommWith.
  * Implemented IOmniTaskGroup.SendToAll.
  * New/updated tests/demos:
    * 10\_Containers
      * 2 -> 2, 1 -> 4 and 4 -> 4 tests for stacks and queues,
      * [1, 2, 4] -> [1, 2, 4] full tests.
      * Writes CSV file with cumulative test results.
    * 17\_MsgWait: demo for the .MsgWait behaviour modifier.
    * 18\_StringMsgDispatch: Invoke demo.
    * 19\_StringMsgBenchmark: Invoke benchmark, ReceiveWait demo.
    * 20\_QuickSort: Parallel quicksort demo.
    * 21\_Anonymous\_methods: Anonymous methods demo (D2009 only).
  * Message ID $FFFF is now reserved for internal purposes.
  * Better default queue length calculation that takes into account OtlContainers overhead and FastMM4 granulation.
  * Bug fixed: TOmniValue.Null was not really initialized to Null.
  * Bug fixed: Setting timer interval resets timer countdown.
  * Bug fixed: TOmniTaskControl.Schedule always scheduled task to the global thread pool.
  * Current versions of 3rd party units included.

# 1.0a: 2008-09-02 #
  * TGp4AlignedInt from GpStuff.pas is supposedly D2006 compatible (says a reader) so it has been enabled on that plaform. As a result, it is now possible to compiled and use OTL in D2006 (said the same source).
  * SpinLock.pas has been updated.
  * Test 6 has been changed to show why one would want to use IOmniWorker.Implementor function.
  * FastMM 4.88 included in the repository to simplify debugging. FastMM4 was created by Pierre le Riche and is not covered by the OmniThreadLibrary license. It is released under a dual licensed and you can use it either under the MPL 1.1 or LGPL 2.1. More details in the included readme file and on the FastMM4 home page.

# 1.0: 2008-08-26 #
  * Initial release.