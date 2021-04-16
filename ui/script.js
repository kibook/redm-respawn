function showHud(killer) {
	if (killer) {
		document.getElementById('killer-name').innerHTML = killer;
		document.getElementById('killer').style.display = 'block';
	} else {
		document.getElementById('killer').style.display = 'none';
	}

	document.getElementById('hud').className = 'visible';
}

function hideHud() {
	document.getElementById('hud').className = 'hidden';
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
			showHud(event.data.killer);
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
