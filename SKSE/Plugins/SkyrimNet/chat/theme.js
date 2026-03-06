// Theme tokens matching the web UI's ThemeContext
const THEMES = {
    dark: {
        bg: '#1a1a2e',
        bgSecondary: '#16213e',
        bgPanel: '#0f3460',
        text: '#e0e0e0',
        textMuted: '#a0a0a0',
        textDim: '#6b7280',
        accent: '#4f9cf7',
        accentHover: '#3b82f6',
        border: '#2d3748',
        playerBubble: '#1e40af',
        playerText: '#dbeafe',
        npcBubble: '#1f4d3a',
        npcText: '#d1fae5',
        systemBubble: '#374151',
        systemText: '#d1d5db',
        inputBg: '#1e293b',
        inputBorder: '#475569',
        inputFocus: '#4f9cf7',
        scrollbar: '#475569',
        scrollbarHover: '#64748b',
        modeBadge: '#374151',
        modeBadgeText: '#93c5fd',
        hoverOverlay: 'rgba(255,255,255,0.05)',
        danger: '#ef4444',
        dangerHover: '#dc2626'
    },
    light: {
        bg: '#f8fafc',
        bgSecondary: '#f1f5f9',
        bgPanel: '#e2e8f0',
        text: '#1e293b',
        textMuted: '#64748b',
        textDim: '#94a3b8',
        accent: '#2563eb',
        accentHover: '#1d4ed8',
        border: '#cbd5e1',
        playerBubble: '#3b82f6',
        playerText: '#ffffff',
        npcBubble: '#22c55e',
        npcText: '#ffffff',
        systemBubble: '#e5e7eb',
        systemText: '#374151',
        inputBg: '#ffffff',
        inputBorder: '#d1d5db',
        inputFocus: '#2563eb',
        scrollbar: '#cbd5e1',
        scrollbarHover: '#94a3b8',
        modeBadge: '#e5e7eb',
        modeBadgeText: '#1e40af',
        hoverOverlay: 'rgba(0,0,0,0.05)',
        danger: '#ef4444',
        dangerHover: '#dc2626'
    }
};

let currentTheme = 'dark';

function getTheme() {
    return THEMES[currentTheme] || THEMES.dark;
}

function applyTheme(themeName) {
    currentTheme = themeName;
    const t = getTheme();
    const root = document.documentElement;
    for (const [key, value] of Object.entries(t)) {
        root.style.setProperty(`--${key}`, value);
    }
}
