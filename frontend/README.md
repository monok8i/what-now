# What Now? - Frontend

A modern, AI-powered caregiver support platform built with Next.js, React, and TypeScript. This application helps people navigate the complexities of caring for an elderly or ill loved one by providing personalized guidance, financial information, and local service recommendations.

**Created for HackujStát 2026** 🇨🇿

## 🎯 Project Overview

**What Now?** ("Co teď?" in Czech) is a web application designed to support caregivers by:

- Guiding users through an interactive questionnaire about their caregiving situation
- Leveraging AI to analyze responses and provide personalized recommendations
- Displaying a comprehensive list of nearby care services and health facilities
- Offering financial and employment guidance specific to the user's circumstances
- Presenting all information in an accessible, user-friendly interface

The platform currently supports Czech language and is optimized for desktop and mobile experiences.

## 🛠️ Tech Stack

### Core Framework
- **Next.js 16.1.6** - React framework with server-side rendering and static generation
- **React 19.2.3** - UI library
- **TypeScript 5** - Static typing for JavaScript

### Styling & UI
- **Tailwind CSS 4** - Utility-first CSS framework
- **@tailwindcss/typography** - Typography plugin for readable prose
- **Lucide React 0.577.0** - Icon library with SVG icons

### Mapping & Geolocation
- **Leaflet 1.9.4** - Interactive mapping library
- **React Leaflet 5.0.0** - React components for Leaflet
- **react-leaflet-cluster** - Marker clustering for large datasets

### Content & Utilities
- **React Markdown 10.1.0** - Markdown rendering in React
- **remark-gfm 4.0.1** - GitHub Flavored Markdown support

### Development Tools
- **ESLint 9** - Code linting and style checking
- **Node.js 20+** - JavaScript runtime (recommended)

## 📁 Project Structure

```
frontend/
├── app/                          # Next.js app directory (pages & layouts)
│   ├── page.tsx                 # Homepage with hero section and info
│   ├── layout.tsx               # Root layout wrapper
│   ├── globals.css              # Global styles and CSS utilities
│   ├── mapa/
│   │   └── page.tsx            # Map page showing all services
│   └── pomoc/
│       └── page.tsx            # Main form/questionnaire page
│
├── components/                   # Reusable React components
│   ├── layout/
│   │   └── Header.tsx           # Navigation header
│   ├── steps/                   # Multi-step form components
│   │   ├── StepOne.tsx         # Relationship & age of care recipient
│   │   ├── StepTwo.tsx         # Health status & financial info
│   │   ├── StepThree.tsx       # Living situation & support network
│   │   └── StepFour.tsx        # User's work situation & concerns
│   └── ui/                      # Reusable UI components
│       ├── ResponseChat.tsx     # AI response display & map modal
│       ├── SelectableCard.tsx   # Option selection component
│       └── CheckboxCard.tsx     # Multi-select option component
│
├── src/
│   └── components/
│       ├── Map.tsx              # Leaflet map with service markers
│       └── MapWrapper.tsx       # Dynamic map loader (SSR-safe)
│
├── types/
│   └── form.ts                  # TypeScript types for form data
│
├── public/                       # Static assets
│   ├── marker-icon.png
│   ├── marker-icon-2x.png
│   └── marker-shadow.png
│
├── package.json                  # Dependencies & scripts
├── tsconfig.json                 # TypeScript configuration
├── tailwind.config.js            # Tailwind CSS configuration
├── next.config.ts                # Next.js configuration
└── README.md                     # This file
```

## 🚀 Getting Started

### Prerequisites

- **Node.js** 18.17 or higher (20+ recommended)
- **npm** or **yarn** package manager
- Docker (optional, for containerized deployment)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/monok8i/what-now.git
   cd what-now/frontend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   # or
   yarn install
   ```

3. **Set up environment variables** (if needed):
   ```bash
   cp .env.example .env.local
   ```
   Configure any required API endpoints or environment variables.

### Running the Development Server

```bash
npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser. The page auto-updates as you edit files.

### Building for Production

```bash
npm run build
npm start
```

The build output is optimized and ready for deployment. The application uses Next.js standalone output mode for containerization.

### Linting

Check code quality with ESLint:

```bash
npm run lint
```

## 📋 Application Flow

### User Journey

1. **Homepage** (`/`)
   - Hero section explaining the service
   - How-it-works overview (3-step process)
   - Benefits summary
   - Sample map preview
   - Call-to-action buttons

2. **Questionnaire** (`/pomoc`)
   - **Step 1**: Who needs care? (relationship, age, gender)
   - **Step 2**: Health status (independence level, financial benefits, situation duration)
   - **Step 3**: Living arrangements (location, postal code, support network)
   - **Step 4**: User's situation (employment, main concerns)
   - Form validation on each step
   - Submit triggers AI analysis

3. **Results**
   - AI-powered analysis and recommendations
   - Personalized guidance displayed via Markdown
   - Interactive map showing nearby services (with user location if available)

4. **Service Map** (`/mapa`)
   - Full-page interactive map with all available services
   - Filterable by distance and region
   - Marker clustering for performance
   - Service details on click

## 🧩 Key Components

### Form Steps
- **StepOne** - Collects information about the care recipient
- **StepTwo** - Assesses health/financial situation
- **StepThree** - Determines living arrangement and family support
- **StepFour** - Gathers user's employment and concerns

Each step uses reusable UI components (`SelectableCard`, `CheckboxCard`) for consistent user experience.

### Map System
- **Map.tsx** - Leaflet integration with custom markers
- **MapWrapper.tsx** - Next.js dynamic import (avoids SSR issues with Leaflet)
- Responsive marker sizing
- Service clustering to handle 100+ locations efficiently

### Response Chat
- **ResponseChat.tsx** - Displays AI responses with formatted Markdown
- Integrates interactive map modal
- Shows loading states with animated messages
- Lists services with distance calculations

## 🎨 Styling

The application uses **Tailwind CSS** for all styling:

- Color scheme: Slate grays with indigo/purple accents
- Responsive design with mobile-first approach
- Custom Leaflet popup styling for compact presentation
- Smooth transitions and hover effects

### Key CSS Classes
- **Compact popups**: `.leaflet-popup-content-wrapper.compact-popup`
- **Animations**: Smooth transitions on hover, fade-in effects
- **Responsive**: Breakpoints at `md:` (768px) and adjustable containers

## 📱 Responsive Design

- Mobile-optimized layout (320px+)
- Tablet-friendly interface (768px+)
- Desktop-enhanced experience (1024px+)
- Touch-friendly button sizes and spacing

## 🗺️ Map Features

- **Interactive markers** for 100+ service locations
- **Marker clustering** at default zoom levels
- **User location indicator** (blue circle if available)
- **Custom popup** with service details:
  - Service name & provider
  - Address & postal code
  - Distance (calculated or provided)
  - Region/district
- **Modal view** for exploring services on results page
- **Service list** sidebar with scrollable results

## 🔌 API Integration

The application communicates with a backend API to:

- Submit form responses
- Receive AI analysis
- Fetch nearby service recommendations
- Calculate distances based on postal codes

Expected API response format:
```typescript
{
  total_chunks: number;
  message: string;           // Markdown formatted response
  map_services: MapService[]; // Array of nearby services
}
```

## 🌐 Language Support

Currently supports **Czech** across the entire interface:
- Form labels and descriptions
- Navigation and buttons
- Loading messages
- AI responses (backend-dependent)
- Map service details

To add additional languages, update text strings in:
- `app/` pages
- `components/steps/` form steps
- `components/layout/` navigation
- Constant arrays in step components

## 🐳 Docker Support

The project is configured for containerization:

```dockerfile
# Dockerfile included for deployment
# Built with standalone output mode for minimal size
```

Build and run with Docker:
```bash
docker build -t what-now-frontend .
docker run -p 3000:3000 what-now-frontend
```

## 📦 Dependencies Note

- **react-leaflet-cluster** is included but currently **unused** (markers render without clustering per recent updates)
- Consider removing if clustering is not needed in future versions

## 🛠️ Development Workflow

1. **Feature branches**: Create branches from `main` for new features
2. **Type safety**: Always maintain TypeScript types for new components
3. **Component reusability**: Use `SelectableCard` and `CheckboxCard` for form inputs
4. **Styling**: Follow Tailwind CSS utility patterns (no custom CSS unless necessary)
5. **Map updates**: Remember to use `dynamic()` import for Map components (SSR incompatibility)

## 🚨 Known Issues & Improvements

- **Clustering**: Currently removed; can be re-enabled with smart bundling logic
- **Marker icons**: Customize further with size variations for better visibility at different zoom levels
- **Loading states**: Can be enhanced with progress indicators
- **Accessibility**: Review ARIA labels and keyboard navigation

## 📚 Further Reading

- [Next.js Documentation](https://nextjs.org/docs)
- [React Documentation](https://react.dev)
- [Tailwind CSS](https://tailwindcss.com)
- [Leaflet Documentation](https://leafletjs.com)
- [TypeScript Handbook](https://www.typescriptlang.org/docs)


## 👥 Contributing

To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Ensure code passes linting and maintains TypeScript strict mode.
