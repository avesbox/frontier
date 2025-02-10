import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Frontier",
  description: "Simple authentication library for Flutter & Dart",
  head: [
    ['link', { rel: "icon", type: "image/png", sizes: "32x32", href: "/logo-32x32.png"}],
    ['link', { rel: "icon", type: "image/png", sizes: "16x16", href: "/logo-16x16.png"}],
    ['meta', { property: 'og:title', content: 'Frontier'}],
    ['meta', { name: 'description', content: 'Simple authentication library for Flutter & Dart'}],
    ['meta', { property: 'og:description', content: 'Simple authentication library for Flutter & Dart'}],
  ],
  lastUpdated: true,
  appearance: false,
  themeConfig: {
    footer: {
      copyright: 'Copyright © 2025 Avesbox',
      message: 'Built with 💙 by <a href="https://avesbox.com">Avesbox</a>'
    },
    // https://vitepress.dev/reference/default-theme-config
    logo: '/logo.png',
    search: {
      provider: 'local'
    },
    
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Docs', link: '/docs/' },
      { text: 'Strategies', link: '/strategies'},
      { text: 'pub.dev', link: 'https://pub.dev/packages/frontier' },
    ],

    sidebar: [
      {
        text: 'Getting Started',
        link: '/',
        base: '/docs/',
        items: [
          {
            'text': 'Use a Strategy',
            'link': 'use-a-strategy'
          },
          {
            text: 'Create a Strategy',
            link: 'create-a-strategy',
          },
          {
            text: 'Integrations',
            link: 'integrations'
          }
        ]
      },
      
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/avesbox' },
      { icon: 'x', link: 'https://x.com/avesboxx' },
      { icon: 'discord', link: 'https://discord.gg/zydgnJ3ksJ' },
      { icon: 'youtube', link: 'https://www.youtube.com/@avesbox' }
    ]
  }
})
