chrome.webRequest.onHeadersReceived.addListener(
  (details) => {
    if (details.url.includes("screen.mp4") || details.url.includes("ssmovie.mp4")) {
      chrome.runtime.sendNativeMessage(
        "com.hanyang.ffmpeg_downloader",
        { url: details.url },
        (response) => {
          if (chrome.runtime.lastError) {
            console.error("Native messaging error:", chrome.runtime.lastError.message);
          } 
          else {
            console.log("Download response:", response);
          }
        }
      );
    }
  },
  { urls: ["<all_urls>"] },
  ["responseHeaders"]
);
