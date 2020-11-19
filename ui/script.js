function showHud() {
	document.getElementById('hud').className = 'visible';
}

function showInstructions() {
	document.querySelectorAll('.instructions').forEach(e => e.className = 'instructions visible');
}

function hideHud() {
	document.getElementById('hud').className = 'hidden';
	document.querySelectorAll('.instructions').forEach(e => e.className = 'instructions hidden');
}

function updateCooldownTimer(timeLeft) {
	var secs = Math.floor(timeLeft / 1000);

	if (secs > 0) {
		document.getElementById('cooldown-timer').className = 'visible';
		document.getElementById('time-left').innerHTML = secs;
	} else {
		document.getElementById('cooldown-timer').className = 'hidden';
	}
}

function toggleHud() {
	var hud = document.getElementById('hud');

	if (hud.className == 'visible') {
		hud.className = 'hidden';
	} else {
		hud.className = 'visible';
	}
}

window.addEventListener('message', event => {
	switch (event.data.type) {
		case 'showHud':
			showHud();
			break;
		case 'showInstructions':
			showInstructions();
			break;
		case 'hideHud':
			hideHud();
			break;
		case 'updateCooldownTimer':
			updateCooldownTimer(event.data.timeLeft);
			break;
		case 'toggleHud':
			toggleHud();
			break;
	}
});
