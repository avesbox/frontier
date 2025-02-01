import DefaultTheme from 'vitepress/theme'
import './style.css'
import FlexHome from '../../components/flexhome.vue'

export default {
    extends: DefaultTheme,
    enhanceApp({ app }) {
        app.component('flexhome', FlexHome)
    }
}