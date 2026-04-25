{ ... }: {
  flake.nixosModules.zacks-nwg-hello = { ... }: {
    startup.nwg-hello = {
      background = ../assets/greeter-background.jpg;

      css = ''
        @define-color hello-bg #1F2430;
        @define-color hello-surface #2A313D;
        @define-color hello-surface-hover #343F4C;
        @define-color hello-surface-strong #232A35;
        @define-color hello-text #E6E1CF;
        @define-color hello-muted #CBCCC6;
        @define-color hello-accent #39BAE6;
        @define-color hello-accent-hover #4D98CC;
        @define-color hello-accent-soft rgba(57, 186, 230, 0.18);
        @define-color hello-accent-soft-hover rgba(57, 186, 230, 0.28);
        @define-color hello-border rgba(77, 152, 204, 0.58);
        @define-color hello-border-strong rgba(115, 208, 255, 0.82);

        /* Keep child containers clear so the window background remains visible. */
        box {
          background-color: transparent;
          background-image: none;
        }

        #form-wrapper {
          background-color: rgba(31, 36, 48, 0.74);
          border-radius: 20px;
          border: 1px solid rgba(77, 152, 204, 0.24);
          padding: 22px;
          min-width: 320px;
        }

        entry {
          background-image: none;
          background-color: rgba(42, 49, 61, 0.88);
          color: @hello-text;
          caret-color: @hello-text;
          border: 1px solid @hello-border;
          border-radius: 18px;
          padding: 8px 12px;
          font-size: 24px;
          box-shadow: none;
          text-shadow: none;
        }

        entry:focus,
        entry:active {
          background-image: none;
          background-color: rgba(35, 42, 53, 0.94);
          color: @hello-text;
          border: 1px solid @hello-border-strong;
          box-shadow: none;
          outline: none;
        }

        button,
        button:hover,
        button:focus,
        button:active,
        button:checked {
          background-image: none;
          background-color: rgba(42, 49, 61, 0.88);
          color: @hello-text;
          border: 1px solid @hello-border;
          border-radius: 18px;
          padding: 8px 14px;
          font-size: 24px;
          box-shadow: none;
          text-shadow: none;
          outline: none;
          -gtk-icon-shadow: none;
        }

        button:hover {
          background-color: rgba(52, 63, 76, 0.94);
          border-color: @hello-border-strong;
        }

        button:focus,
        button:active,
        button:checked {
          background-color: rgba(35, 42, 53, 0.96);
          border-color: @hello-border-strong;
        }

        button label,
        button image {
          color: @hello-text;
          -gtk-icon-shadow: none;
        }

        #power-button {
          border-radius: 18px;
          background-image: none;
          background-color: rgba(42, 49, 61, 0.68);
          border: 1px solid rgba(77, 152, 204, 0.38);
          color: @hello-text;
          padding: 10px 16px;
          font-size: 26px;
        }

        #power-button:hover {
          background-color: rgba(52, 63, 76, 0.84);
          border-color: @hello-border-strong;
        }

        #power-button:active {
          background-color: rgba(57, 186, 230, 0.22);
          border-color: @hello-accent;
        }

        label {
          color: @hello-text;
          font-size: 24px;
        }

        checkbutton {
          color: @hello-muted;
          font-size: 24px;
        }

        checkbutton check {
          background-image: none;
          background-color: rgba(42, 49, 61, 0.88);
          border: 1px solid @hello-border;
          border-radius: 6px;
          box-shadow: none;
        }

        checkbutton check:checked,
        checkbutton check:hover,
        checkbutton check:focus {
          background-image: none;
          background-color: rgba(57, 186, 230, 0.24);
          border-color: @hello-border-strong;
        }

        combobox,
        combobox button,
        #form-combo {
          background-image: none;
          background-color: rgba(42, 49, 61, 0.88);
          color: @hello-text;
          border-radius: 18px;
          border: 1px solid @hello-border;
          font-size: 24px;
          box-shadow: none;
          text-shadow: none;
        }

        combobox box,
        combobox button box,
        combobox button label,
        combobox arrow {
          background-image: none;
          background-color: transparent;
          border: none;
          box-shadow: none;
          text-shadow: none;
        }

        #welcome-label {
          color: @hello-text;
          font-size: 56px;
          font-weight: 300;
        }

        #clock-label {
          color: #73D0FF;
          font-family: monospace;
          font-size: 40px;
          letter-spacing: 0.05em;
        }

        #date-label {
          color: @hello-muted;
          font-size: 28px;
        }

        #form-label {
          color: @hello-muted;
          font-size: 24px;
        }

        #form-combo {
          background-color: rgba(42, 49, 61, 0.88);
        }

        #password-entry {
          background-color: rgba(42, 49, 61, 0.88);
          color: @hello-text;
          font-size: 22px;
        }

        #login-button {
          background-image: none;
          background-color: @hello-accent-soft;
          color: @hello-text;
          border: 1px solid rgba(57, 186, 230, 0.52);
          border-radius: 18px;
          padding: 10px;
          font-size: 24px;
          margin-top: 4px;
          box-shadow: none;
          text-shadow: none;
          outline: none;
        }

        #login-button:hover,
        #login-button:focus {
          background-image: none;
          background-color: @hello-accent-soft-hover;
          border-color: @hello-accent-hover;
        }

        #login-button:active {
          background-image: none;
          background-color: rgba(77, 152, 204, 0.3);
          border-color: #73D0FF;
        }
      '';
    };
  };
}
