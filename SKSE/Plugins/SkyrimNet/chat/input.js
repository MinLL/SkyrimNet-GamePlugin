// Input field with prefix parsing and autocomplete
const MODE_PREFIXES = {
    '~': 'Think',
    '!': 'Narrate',
    '/think': 'Think',
    '/narrate': 'Narrate',
    '/silent': 'Silent',
    '/transform': 'Transform',
    '@': 'Direct'
};

let currentMode = 'Say';
let autocompleteVisible = false;
let autocompleteIndex = 0;
let autocompleteMatches = [];

function initInput() {
    const input = document.getElementById('chat-input');
    const sendBtn = document.getElementById('send-btn');
    if (!input) return;

    input.addEventListener('input', onInputChange);
    input.addEventListener('keydown', onInputKeydown);
    if (sendBtn) sendBtn.addEventListener('click', submitInput);
}

function onInputChange() {
    updateModeFromInput();
    updateAutocomplete();
}

function updateModeFromInput() {
    const input = document.getElementById('chat-input');
    const badge = document.getElementById('mode-badge');
    if (!input || !badge) return;

    const val = input.value;
    let mode = 'Say';

    if (val.startsWith('~')) mode = 'Think';
    else if (val.startsWith('!')) mode = 'Narrate';
    else if (val.startsWith('@')) mode = 'Direct';
    else {
        const lower = val.toLowerCase();
        if (lower.startsWith('/think')) mode = 'Think';
        else if (lower.startsWith('/narrate')) mode = 'Narrate';
        else if (lower.startsWith('/silent')) mode = 'Silent';
        else if (lower.startsWith('/transform')) mode = 'Transform';
    }

    currentMode = mode;
    badge.textContent = mode;
    badge.className = 'mode-badge mode-badge--' + mode.toLowerCase();
}

function updateAutocomplete() {
    const input = document.getElementById('chat-input');
    const dropdown = document.getElementById('autocomplete-dropdown');
    if (!input || !dropdown) return;

    const val = input.value;

    // Only show autocomplete for @ prefix
    if (!val.startsWith('@')) {
        hideAutocomplete();
        return;
    }

    const partial = val.substring(1).split(' ')[0].toLowerCase();
    if (partial.length === 0) {
        autocompleteMatches = getActorNames();
    } else {
        autocompleteMatches = getActorNames().filter(n =>
            n.toLowerCase().startsWith(partial)
        );
    }

    if (autocompleteMatches.length === 0) {
        hideAutocomplete();
        return;
    }

    autocompleteIndex = 0;
    showAutocomplete();
}

function showAutocomplete() {
    const dropdown = document.getElementById('autocomplete-dropdown');
    if (!dropdown) return;

    dropdown.innerHTML = '';
    autocompleteMatches.forEach((name, i) => {
        const item = document.createElement('div');
        item.className = 'autocomplete__item' + (i === autocompleteIndex ? ' autocomplete__item--active' : '');
        item.textContent = name;
        item.onclick = () => selectAutocomplete(name);
        dropdown.appendChild(item);
    });

    dropdown.style.display = 'block';
    autocompleteVisible = true;
}

function hideAutocomplete() {
    const dropdown = document.getElementById('autocomplete-dropdown');
    if (dropdown) dropdown.style.display = 'none';
    autocompleteVisible = false;
    autocompleteMatches = [];
}

function selectAutocomplete(name) {
    const input = document.getElementById('chat-input');
    if (!input) return;

    input.value = '@' + name + ' ';
    input.focus();
    hideAutocomplete();
    updateModeFromInput();
}

function onInputKeydown(e) {
    // Autocomplete navigation
    if (autocompleteVisible) {
        if (e.key === 'ArrowDown') {
            e.preventDefault();
            autocompleteIndex = Math.min(autocompleteIndex + 1, autocompleteMatches.length - 1);
            showAutocomplete();
            return;
        }
        if (e.key === 'ArrowUp') {
            e.preventDefault();
            autocompleteIndex = Math.max(autocompleteIndex - 1, 0);
            showAutocomplete();
            return;
        }
        if (e.key === 'Tab' || (e.key === 'Enter' && autocompleteMatches.length > 0 && autocompleteVisible)) {
            e.preventDefault();
            if (autocompleteMatches[autocompleteIndex]) {
                selectAutocomplete(autocompleteMatches[autocompleteIndex]);
            }
            return;
        }
    }

    if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        submitInput();
    }

    if (e.key === 'Escape') {
        e.preventDefault();
        if (autocompleteVisible) {
            hideAutocomplete();
        } else {
            closeChat();
        }
    }
}

function submitInput() {
    const input = document.getElementById('chat-input');
    if (!input || !input.value.trim()) return;

    const text = input.value.trim();
    input.value = '';
    updateModeFromInput();
    hideAutocomplete();

    if (window.skyrimnet && window.skyrimnet.chatSubmit) {
        window.skyrimnet.chatSubmit(JSON.stringify({ text: text }));
    }
}

function closeChat() {
    if (window.skyrimnet && window.skyrimnet.chatClose) {
        window.skyrimnet.chatClose('');
    }
}
