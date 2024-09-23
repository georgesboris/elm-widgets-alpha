/** @type {import('tailwindcss').Config} */
module.exports = {
  prefix: "w--",
  content: ["./src/**/*.elm", "../src/**/*.elm", "!../src/W/Styles.elm"],
  corePlugins: { preflight: false },
  plugins: [
    require("w-theme/tailwindcss")({
      strict: true,
      useSpacing: true,
      strictSpacing: true,
      colorComponents: true
    })
  ],
  theme: {
    extend: {
      keyframes: {
        "w--animation-fade-slide": {
          from: {
            opacity: 0,
            transform: "translateY(10px) scale(0.9)",
          },
          to: {
            opacity: 1,
            transform: "translateY(0) scale(1)"
          },
        }
      },
      animation: {
        "fade-slide": "w--animation-fade-slide 0.4s ease-out",
      }
    }
  }
}

