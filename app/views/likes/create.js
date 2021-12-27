window.addEventListener("load", () => {
    const element = document.querySelector("#memes-body");
    element.addEventListener("ajax:success", (event) => {
      const [_data, _status, xhr] = event.detail;
      element.insertAdjacentHTML("beforeend", xhr.responseText);
    });
    element.addEventListener("ajax:error", () => {
      element.insertAdjacentHTML("beforeend", "<p>ERROR</p>");
    });
  });
  
  