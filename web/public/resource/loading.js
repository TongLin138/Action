const appSelector = '.app-loading-wrapper'
const appLogoTitle = 'Arcadia'

initSvgLogo()
genLogoTitle(appLogoTitle)

function initSvgLogo(selector = appSelector) {
  const svgStr = `<img class="app-logo" src="../logo.png">`;
  const appEl = document.querySelector(selector);
  const div = document.createElement('div');
  div.innerHTML = svgStr;
  div.setAttribute('class', 'app-logo')
  if (appEl) {
    appEl.appendChild(div);
  }
}

function genLogoTitle(title,selector=appSelector ) {
  const appEl = document.querySelector(selector);
  const div = document.createElement('div');
  div.setAttribute('class', 'app-title')
 
  for (let i = 0; i < title.length; i++) {
    const letter = title[i]
    let letterNode = document.createElement('span');
    if(letter === ' ') {
      div.innerHTML = div.innerHTML + '&nbsp;'
    } else { 
      letterNode.innerHTML = letter
      letterNode.setAttribute('class', 'app-title-letter')
      letterNode.style.animationDelay = `${280 + 120 * i}ms`
      div.appendChild(letterNode)
    }
  }
  if (appEl) {
    appEl.appendChild(div);
  }
}
