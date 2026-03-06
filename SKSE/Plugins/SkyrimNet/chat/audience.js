// Nearby NPC panel rendering
let audienceData = { actors: [], whisperMode: false, whisperRadius: 0 };

function setAudience(data) {
    if (typeof data === 'string') {
        try { data = JSON.parse(data); } catch { return; }
    }
    audienceData = data || { actors: [], whisperMode: false, whisperRadius: 0 };
    renderAudience();
}

function renderAudience() {
    const container = document.getElementById('audience-list');
    const whisperBadge = document.getElementById('whisper-badge');
    if (!container) return;

    // Update whisper badge
    if (whisperBadge) {
        whisperBadge.textContent = audienceData.whisperMode ? 'Whisper: ON' : 'Whisper: OFF';
        whisperBadge.className = 'whisper-badge' + (audienceData.whisperMode ? ' whisper-badge--active' : '');
    }

    container.innerHTML = '';

    if (!audienceData.actors || audienceData.actors.length === 0) {
        const empty = document.createElement('div');
        empty.className = 'audience__empty';
        empty.textContent = 'No NPCs nearby';
        container.appendChild(empty);
        return;
    }

    // Sort by distance
    const sorted = [...audienceData.actors].sort((a, b) => (a.distance || 0) - (b.distance || 0));

    for (const actor of sorted) {
        const el = document.createElement('div');
        el.className = 'audience__actor';

        const dot = document.createElement('span');
        dot.className = 'audience__dot';
        el.appendChild(dot);

        const name = document.createElement('span');
        name.className = 'audience__name';
        name.textContent = actor.name;
        el.appendChild(name);

        const dist = document.createElement('span');
        dist.className = 'audience__distance';
        dist.textContent = `(${actor.distance || 0}m)`;
        el.appendChild(dist);

        // Click to insert @mention
        el.onclick = () => insertMention(actor.name);

        container.appendChild(el);
    }
}

function insertMention(name) {
    const input = document.getElementById('chat-input');
    if (!input) return;

    // If input is empty or starts with @, replace with @Name
    if (!input.value || input.value.startsWith('@')) {
        input.value = '@' + name + ' ';
    } else {
        // Append @Name at cursor position
        const pos = input.selectionStart || input.value.length;
        input.value = input.value.substring(0, pos) + '@' + name + ' ' + input.value.substring(pos);
    }

    input.focus();
    updateModeFromInput();
}

function getActorNames() {
    return (audienceData.actors || []).map(a => a.name);
}
