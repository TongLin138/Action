const appSelector = ".app-loading-wrapper";
const appLogoTitle = "Arcadia";

// 动态更新加载动画主题
try {
  const themeState = localStorage.getItem("__APP__THEME__STATE__") || "light";
  const isMobile = window.matchMedia("(max-width: 996px)").matches;
  const metaThemeColor = document.querySelector('meta[name=theme-color]');
  if (!isMobile) {
    document.documentElement.style.setProperty(
      "--app-loading-background",
      themeState === "light"
        ? "linear-gradient(to bottom, #D5DEE7 0%, #E8EBF2 50%, #E2E7ED 100%), linear-gradient(to bottom, rgba(0,0,0,0.02) 50%, rgba(255,255,255,0.02) 61%, rgba(0,0,0,0.02) 73%), linear-gradient(33deg, rgba(255,255,255,0.20) 0%, rgba(0,0,0,0.20) 100%)"
        : "linear-gradient(60deg, #29323c 0%, #485563 100%)",
    );
    if (metaThemeColor) {
      metaThemeColor.setAttribute('content', '#ffffff');
    }
  } else {
    document.documentElement.style.setProperty(
      "--app-loading-background",
      themeState === "light" ? "linear-gradient(#FFF, #FFF)" : "linear-gradient(rgb(24, 24, 28), rgb(24, 24, 28))",
    );
    if (metaThemeColor) {
      metaThemeColor.setAttribute('content', '#18181c');
    }
  }
  document.documentElement.style.setProperty(
    "--app-loading-title-color",
    themeState === "light" ? "#000" : "#FFF",
  );
} catch (error) {
  console.error("Failed to update loading animation theme:", error);
}

function initSvgLogo(selector = appSelector) {
  const logoHerf =
    "data:image/png;base64,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";
  const svgStr = `<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="527px" height="527px" viewBox="0 0 527 527" enable-background="new 0 0 527 527" xml:space="preserve"> <image id="image0" width="138" height="138" x="0" y="0" href="${logoHerf}" /></svg>`;
  const appEl = document.querySelector(selector);
  const div = document.createElement("div");
  div.innerHTML = svgStr;
  div.setAttribute("class", "app-logo");
  if (appEl) {
    appEl.appendChild(div);
  }
}

function genLogoTitle(title, selector = appSelector) {
  const appEl = document.querySelector(selector);
  const div = document.createElement("div");
  div.setAttribute("class", "app-title");

  for (let i = 0; i < title.length; i++) {
    const letter = title[i];
    let letterNode = document.createElement("span");
    if (letter === " ") {
      div.innerHTML = div.innerHTML + "&nbsp;";
    } else {
      letterNode.innerHTML = letter;
      letterNode.setAttribute("class", "app-title-letter");
      letterNode.style.animationDelay = `${280 + 120 * i}ms`;
      div.appendChild(letterNode);
    }
  }
  if (appEl) {
    appEl.appendChild(div);
  }
}

initSvgLogo();
genLogoTitle(appLogoTitle);
