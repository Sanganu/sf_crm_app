@isTest
private class TriggerHandlerTest {
    
    // Subclass that exposes protected methods for testing
    private class TestHandler extends TriggerHandler {
        public override void beforeInsert() {}
        public override void beforeUpdate() {}
        public override void beforeDelete() {}
        public override void afterInsert()  {}
        public override void afterUpdate()  {}
        public override void afterDelete()  {}
    }

    @isTest
    static void triggerHandler_covers_unused_methods() {
        TestHandler handler = new TestHandler();
        handler.beforeInsert();
        handler.beforeUpdate();
        handler.beforeDelete();
        handler.afterInsert();
        handler.afterUpdate();
        handler.afterDelete();
    }
}