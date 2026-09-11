'use strict';

// Hyper configuration. See https://hyper.is/#cfg
module.exports = {
  config: {
    updateChannel: 'stable',
    fontSize: 13,
    fontFamily: '"JetBrainsMono Nerd Font", "JetBrainsMono NF", "Cascadia Code", Consolas, "Courier New", monospace',
    fontWeight: 'normal',
    fontWeightBold: 'bold',
    lineHeight: 1.2,
    letterSpacing: 0,
    cursorColor: 'rgba(248,28,229,0.8)',
    cursorAccentColor: '#000',
    cursorShape: 'BLOCK',
    cursorBlink: true,
    foregroundColor: '#eff0eb',
    backgroundColor: '#282a36',
    selectionColor: 'rgba(255,255,255,0.15)',
    borderColor: '#222430',
    css: '',
    termCSS: '',
    padding: '14px 18px',
    colors: {
      black: '#282a36', red: '#ff5c57', green: '#5af78e', yellow: '#f3f99d',
      blue: '#57c7ff', magenta: '#ff6ac1', cyan: '#9aedfe', white: '#f1f1f0',
      lightBlack: '#686868', lightRed: '#ff5c57', lightGreen: '#5af78e', lightYellow: '#f3f99d',
      lightBlue: '#57c7ff', lightMagenta: '#ff6ac1', lightCyan: '#9aedfe', lightWhite: '#eff0eb'
    },
    // PowerShell 7. Falls back to Windows PowerShell if pwsh is not installed.
    shell: 'pwsh.exe',
    shellArgs: [],
    env: {},
    bell: 'false',
    copyOnSelect: false,
    quickEdit: false,
    webGLRenderer: true,
    disableLigatures: false
  },
  plugins: ['hyper-snazzy', 'hyper-statusline'],
  localPlugins: [],
  keymaps: {}
};
