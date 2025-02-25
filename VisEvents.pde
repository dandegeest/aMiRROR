@FunctionalInterface
interface VisEvent {
    void fire();
}

HashMap<Character, VisEvent> keyEvents = new HashMap();
