(function () {
    const container = document.getElementById('error-container');
    const list = document.getElementById('error-list');
    if (!container || !list) {
        return;
    }

    const seenMessages = new Set();

    function hideSpinner() {
        const spinner = document.querySelector('.spinner');
        if (spinner) {
            spinner.style.display = 'none';
        }
    }

    function normalizeMessage(value) {
        if (!value) {
            return '';
        }
        if (typeof value === 'string') {
            return value;
        }
        if (value && typeof value.message === 'string') {
            return value.message;
        }
        try {
            return JSON.stringify(value);
        } catch (error) {
            return String(value);
        }
    }

    function showError(message) {
        const text = message || 'Unknown error.';
        if (!seenMessages.has(text)) {
            seenMessages.add(text);
            const entry = document.createElement('li');
            entry.textContent = text;
            list.appendChild(entry);
        }
        container.hidden = false;
        hideSpinner();
    }

    window.addEventListener('error', function (event) {
        showError(event?.message);
    });

    window.addEventListener('unhandledrejection', function (event) {
        const text = normalizeMessage(event?.reason);
        showError(text);
    });
})();

(function () {
    const userLang = (navigator.language || navigator.userLanguage || 'en').slice(0, 2);

    const supportEmail = "support@sharezone.net";
    const translations = {
        en: `An error occurred. Please reload the page. If the problem persists, contact <a href="mailto:${supportEmail}">${supportEmail}</a>.`,
        de: `Ein Fehler ist aufgetreten. Bitte lade die Seite neu. Wenn das Problem weiterhin besteht, kontaktiere uns unter <a href="mailto:${supportEmail}">${supportEmail}</a>.`
    };

    const t = translations[userLang] || translations.en;

    const errorContainer = document.getElementById('error-container');
    if (errorContainer) {
        errorContainer.querySelectorAll('p')[0].innerHTML = t;
    }
})();