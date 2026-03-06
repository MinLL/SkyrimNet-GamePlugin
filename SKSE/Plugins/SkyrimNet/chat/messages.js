// Message list rendering
let messages = [];

function setMessages(newMessages) {
    messages = Array.isArray(newMessages) ? newMessages : [];
    renderMessages();
}

function renderMessages() {
    const container = document.getElementById('message-list');
    if (!container) return;

    const wasScrolledToBottom = container.scrollHeight - container.scrollTop - container.clientHeight < 50;

    container.innerHTML = '';

    for (const msg of messages) {
        const el = createMessageElement(msg);
        container.appendChild(el);
    }

    if (wasScrolledToBottom) {
        container.scrollTop = container.scrollHeight;
    }
}

function createMessageElement(msg) {
    const div = document.createElement('div');
    div.className = 'message';
    div.dataset.id = msg.id || '';

    const type = classifyMessage(msg);
    div.classList.add(`message--${type}`);

    // Header with speaker name and time
    const header = document.createElement('div');
    header.className = 'message__header';

    const speaker = document.createElement('span');
    speaker.className = 'message__speaker';
    speaker.textContent = getSpeakerName(msg);
    header.appendChild(speaker);

    if (msg.gameTimeStr) {
        const time = document.createElement('span');
        time.className = 'message__time';
        time.textContent = msg.gameTimeStr;
        header.appendChild(time);
    }

    div.appendChild(header);

    // Message body
    const body = document.createElement('div');
    body.className = 'message__body';
    body.textContent = getMessageText(msg);
    div.appendChild(body);

    // Action buttons on hover
    if (msg.id) {
        const actions = document.createElement('div');
        actions.className = 'message__actions';

        const editBtn = document.createElement('button');
        editBtn.className = 'message__action-btn';
        editBtn.textContent = 'Edit';
        editBtn.onclick = (e) => { e.stopPropagation(); onEditMessage(msg); };
        actions.appendChild(editBtn);

        const deleteBtn = document.createElement('button');
        deleteBtn.className = 'message__action-btn message__action-btn--danger';
        deleteBtn.textContent = 'Delete';
        deleteBtn.onclick = (e) => { e.stopPropagation(); onDeleteMessage(msg); };
        actions.appendChild(deleteBtn);

        div.appendChild(actions);
    }

    return div;
}

function classifyMessage(msg) {
    const type = (msg.type || '').toLowerCase();
    if (type === 'speech') {
        // Check if this is player speech
        const data = parseEventData(msg.data);
        if (data && data.isPlayer) return 'player';
        return 'npc';
    }
    if (type === 'direct_narration' || type === 'persistent_generic') return 'system';
    if (type === 'player_thought') return 'player';
    return 'system';
}

function getSpeakerName(msg) {
    const data = parseEventData(msg.data);
    if (data && data.speaker) return data.speaker;
    if (data && data.name) return data.name;

    const type = (msg.type || '').toLowerCase();
    if (type === 'direct_narration') return 'Narrator';
    if (type === 'persistent_generic') return 'System';

    return 'Unknown';
}

function getMessageText(msg) {
    const data = parseEventData(msg.data);
    if (data && data.line) return data.line;
    if (data && data.narration) return data.narration;
    if (data && data.text) return data.text;
    if (typeof msg.data === 'string') return msg.data;
    return '';
}

function parseEventData(data) {
    if (!data) return null;
    if (typeof data === 'object') return data;
    try {
        return JSON.parse(data);
    } catch {
        return null;
    }
}

function onEditMessage(msg) {
    const text = getMessageText(msg);
    const newText = prompt('Edit message:', text);
    if (newText !== null && newText !== text) {
        if (window.skyrimnet && window.skyrimnet.eventEdit) {
            window.skyrimnet.eventEdit(JSON.stringify({ id: msg.id, data: newText }));
        }
    }
}

function onDeleteMessage(msg) {
    if (confirm('Delete this message?')) {
        if (window.skyrimnet && window.skyrimnet.eventDelete) {
            window.skyrimnet.eventDelete(JSON.stringify({ id: msg.id }));
        }
    }
}
