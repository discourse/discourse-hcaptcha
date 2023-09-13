import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { next } from "@ember/runloop";
import { inject as service } from "@ember/service";

const HCAPTCHA_SCRIPT_URL = "https://hcaptcha.com/1/api.js?render=explicit";

export default class HCaptcha extends Component {
  @service hCaptchaService;

  @tracked widgetId;
  @tracked invalid = true;
  hCaptcha;

  constructor() {
    super(...arguments);
    this.initializeHCaptcha(this.args.siteKey);
  }

  initializeHCaptcha(siteKey) {
    if (this.isHCaptchaLoaded()) {
      next(() => {
        if (document.getElementById("h-captcha-field")) {
          this.renderHCaptcha(siteKey);
        }
      });
      return;
    }

    this.loadHCaptchaScript(siteKey);
  }

  isHCaptchaLoaded() {
    return typeof this.hCaptcha !== "undefined";
  }

  loadHCaptchaScript(siteKey) {
    let hCaptchaScript = document.createElement("script");
    hCaptchaScript.src = HCAPTCHA_SCRIPT_URL;
    hCaptchaScript.async = true;
    hCaptchaScript.defer = true;
    hCaptchaScript.onload = () => {
      this.hCaptcha = window.hcaptcha;
      this.renderHCaptcha(siteKey);
    };
    document.head.appendChild(hCaptchaScript);
  }

  renderHCaptcha(siteKey) {
    if (!this.isHCaptchaLoaded()) {
      throw new Error("hCaptcha is not defined");
    }

    this.widgetId = this.hCaptcha.render("h-captcha-field", {
      sitekey: siteKey,
      callback: (response) => {
        this.hCaptchaService.token = response;
        this.hCaptchaService.invalid = !response;

        if (response) {
        }
      },
      "expired-callback": () => {
        this.hCaptchaService.invalid = true;
      },
    });

    this.hCaptchaService.registerWidget(this.hCaptcha, this.widgetId);
  }

  willDestroy() {
    if (this.isHCaptchaLoaded()) {
      this.hCaptcha.reset(this.widgetId);
    }
  }
}
