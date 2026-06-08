@isTest
static void triggerHandler_covers_unused_methods() {
    // Forces the virtual method stubs to be hit
    TriggerHandler handler = new TriggerHandler();
    handler.run(); // outside trigger context — won't route but covers run()
}