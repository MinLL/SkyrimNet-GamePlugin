// Main app: PrismaUI bridge and initialization

// C++ -> JS bridge functions (called via InteropCall)
window.updateMessages = function(json) {
    try {
        const data = typeof json === 'string' ? JSON.parse(json) : json;
        setMessages(data);
    } catch (e) {
        console.error('updateMessages error:', e);
    }
};

window.updateAudience = function(json) {
    try {
        const data = typeof json === 'string' ? JSON.parse(json) : json;
        setAudience(data);
    } catch (e) {
        console.error('updateAudience error:', e);
    }
};

window.setTheme = function(theme) {
    applyTheme(theme || 'dark');
};

// JS -> C++ bridge (PrismaUI RegisterJSListener targets)
window.skyrimnet = {
    chatSubmit: function(json) {},
    chatClose: function() {},
    eventEdit: function(json) {},
    eventDelete: function(json) {},
    requestRefresh: function() {}
};

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    applyTheme('dark');
    initInput();

    // Focus input on load
    const input = document.getElementById('chat-input');
    if (input) input.focus();

    // Request initial data
    if (window.skyrimnet && window.skyrimnet.requestRefresh) {
        window.skyrimnet.requestRefresh('');
    }
});
