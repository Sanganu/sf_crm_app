Here is the exact same content formatted as raw Markdown so you can easily copy and paste it directly into a `.md` file (like on GitHub, Notion, or Obsidian):

```markdown
# Salesforce Core Concepts Explained

---

## 1. 📦 What is an Object?

An **Object** in Salesforce is like a **database table** that stores specific types of data. It has **fields** (columns) and **records** (rows).

### Types of Objects

| Type | Description | Examples |
|------|-------------|---------|
| **Standard Objects** | Pre-built objects provided by Salesforce | Account, Contact, Lead, Opportunity, Case |
| **Custom Objects** | Created by users for specific business needs | Custom_Object__c (e.g., Property__c, Invoice__c) |
| **External Objects** | Maps to data outside Salesforce | Data from ERP, external databases |

### Anatomy of an Object

```
Object: Account
├── Fields (Columns)
│   ├── Account Name (Text)
│   ├── Phone (Phone)
│   ├── Industry (Picklist)
│   └── Annual Revenue (Currency)
│
├── Records (Rows)
│   ├── Record 1: "Acme Corp" | 123-456 | Technology | $1M
│   ├── Record 2: "Beta Inc"  | 789-012 | Healthcare | $2M
│   └── Record 3: "Gamma LLC" | 345-678 | Finance    | $3M
│
└── Relationships
    ├── Lookup Relationship (loose link)
    └── Master-Detail Relationship (tight link)
```

### Key Points
- **Custom objects** always have `__c` suffix (e.g., `Property__c`)
- Every object gets **standard fields** automatically: `Id`, `CreatedDate`, `LastModifiedDate`, `OwnerId`
- Objects support **validation rules**, **triggers**, **page layouts**, and **record types**

---

## 2. 🗂️ Tabs

A **Tab** is a **navigation element** in the Salesforce UI that allows users to access an object or a specific feature.

### Types of Tabs

| Type | Description | Example |
|------|-------------|---------|
| **Standard Tabs** | Pre-built tabs for standard objects | Accounts tab, Contacts tab |
| **Custom Object Tabs** | Tabs for custom objects | Property tab, Invoice tab |
| **Web Tabs** | Links to external websites | Link to company intranet |
| **Visualforce Tabs** | Custom Visualforce pages | Custom dashboard page |

### How Tabs Work

```
┌──────────────────────────────────────────────────┐
│  App Launcher / Navigation Bar                    │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐  │
│  │Home  │ │Accts │ │Conts│ │Leads │ │Opps  │  │ ← TABS
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘  │
│                                                    │
│  Clicking a tab → Takes you to that object's      │
│  homepage (list view, recent records, etc.)        │
└──────────────────────────────────────────────────┘
```

### Tab Visibility Settings
- **Default On** — Tab is visible to users
- **Default Off** — Tab is hidden but users can add it
- **Tab Hidden** — Tab is completely hidden

> Tabs are **assigned to Apps** and controlled through **Profiles** and **Permission Sets**.

---

## 3. 🏠 Lighthouse App (Example App)

**Lighthouse** is a **sample/reference application** in Salesforce that demonstrates best practices for building apps on the platform. It is commonly used in **Trailhead** trails and Salesforce documentation.

### Purpose
- **Learning tool** — teaches Salesforce development patterns
- **Reference architecture** — shows how to structure a real app
- **Demonstrates features** — flows, LWC, Apex, security, etc.

### What It Models
Lighthouse typically represents a **volunteer/event management** or **inspection management** scenario:

```
Lighthouse App Structure:
│
├── Objects
│   ├── Property__c          (Properties to inspect)
│   ├── Inspection__c        (Inspection records)
│   └── Inspector__c         (Inspectors/Volunteers)
│
├── Components
│   ├── Lightning Web Components (LWC)
│   └── Aura Components
│
├── Automation
│   ├── Flows
│   ├── Apex Triggers
│   └── Validation Rules
│
├── UI
│   ├── Custom Tabs
│   ├── App Page
│   └── Record Pages
│
└── Security
    ├── Profiles
    ├── Permission Sets
    └── Sharing Rules
```

### Key Takeaways from the Lighthouse App
- Shows how **objects relate** to each other
- Demonstrates **declarative vs. programmatic** solutions
- Teaches **app-level design** — bringing tabs, objects, and automation together

---

## 4. 🔄 Overall Workflow of Salesforce

### The Big Picture

```
┌─────────────────────────────────────────────────────┐
│                  SALESFORCE WORKFLOW                  │
│                                                       │
│  1. SETUP & CONFIGURE                                │
│     ↓                                                 │
│  2. DATA MODELING (Objects, Fields, Relationships)   │
│     ↓                                                 │
│  3. UI CUSTOMIZATION (Tabs, Apps, Page Layouts)      │
│     ↓                                                 │
│  4. AUTOMATION (Flows, Triggers, Rules)              │
│     ↓                                                 │
│  5. SECURITY & ACCESS (Profiles, Permissions)        │
│     ↓                                                 │
│  6. REPORTS & DASHBOARDS                             │
│     ↓                                                 │
│  7. DEPLOY & MAINTAIN                                │
└─────────────────────────────────────────────────────┘
```

### Detailed Breakdown

#### Step 1: 🏗️ Setup & Configure
```
- Create a Salesforce Org (Production / Sandbox / Developer Edition)
- Define company settings
- Enable features and licenses
```

#### Step 2: 📊 Data Modeling
```
Create Objects & Fields
├── Standard Objects (already present)
├── Custom Objects (create as needed)
├── Fields & Field Types (text, number, picklist, lookup, etc.)
├── Relationships (Lookup, Master-Detail, Many-to-Many)
└── Validation Rules (data quality)
```

#### Step 3: 🎨 UI Customization
```
Customize the User Interface
├── Apps (collection of tabs)
├── Tabs (navigation to objects)
├── Page Layouts (field arrangement on record pages)
├── Lightning Record Pages (dynamic components)
├── List Views (filtered record lists)
└── Compact Layouts (key fields shown in highlights)
```

#### Step 4: ⚙️ Automation
```
Automate Business Processes
├── Declarative (No Code)
│   ├── Flows (most powerful — screen flows, record-triggered, etc.)
│   ├── Process Builder (legacy — migrating to Flow)
│   ├── Workflow Rules (legacy — migrating to Flow)
│   └── Approval Processes (multi-step approvals)
│
└── Programmatic (Code)
    ├── Apex Triggers (before/after insert, update, delete)
    ├── Apex Classes (complex business logic)
    ├── Lightning Web Components (custom UI)
    └── Batch/Scheduled Apex (async processing)
```

#### Step 5: 🔐 Security & Access
```
Control Who Sees What
├── Organization-level (login hours, IP ranges)
├── Object-level (CRUD permissions)
├── Field-level (FLS — field visibility/editability)
├── Record-level
│   ├── Role Hierarchy
│   ├── Sharing Rules
│   ├── Manual Sharing
│   └── Territory Management
├── Profiles (baseline access)
└── Permission Sets (additional access)
```

#### Step 6: 📈 Reports & Dashboards
```
Analyze Data
├── Report Types (tabular, summary, matrix, joined)
├── Reports (filtered data views)
├── Dashboards (visual charts & metrics)
├── Dashboards Components (bar chart, pie chart, gauge, etc.)
└── Report Folders & Sharing
```

#### Step 7: 🚀 Deploy & Maintain
```
Move Changes & Ongoing Maintenance
├── Change Set (classic deployment)
├── Salesforce CLI / SFDX (modern deployment)
├── CI/CD Pipelines
├── Sandbox → Production migration
├── Monitoring & Debug Logs
└── AppExchange (install third-party packages)
```

---

## 📋 End-to-End Example: How It All Connects

```
Business Need: Track Property Inspections
│
├── 1. Create Custom Object: Inspection__c
│   ├── Fields: Status__c, Score__c, Inspector__c
│   └── Relationship: Lookup to Property__c
│
├── 2. Create Tab: "Inspections" tab
│   └── Add tab to "Lighthouse" App
│
├── 3. Create App: "Lighthouse" App
│   └── Includes: Properties, Inspections, Inspectors tabs
│
├── 4. Automation:
│   ├── Flow: Auto-assign inspector when inspection created
│   └── Validation: Score must be 1-100
│
├── 5. Security:
│   ├── Inspectors see only their own inspections
│   └── Managers see all inspections
│
├── 6. Reports:
│   ├── "Inspections This Month" report
│   └── Dashboard with inspection score averages
│
└── 7. Deploy:
    └── Move from Sandbox → Production
```

---

## 🧠 Quick Summary

| Concept | One-Line Definition |
|---------|-------------------|
| **Object** | Database table to store data (standard or custom) |
| **Tab** | Navigation element to access an object/feature |
| **Lighthouse App** | Sample Salesforce app for learning best practices |
| **Workflow** | End-to-end process: Model → UI → Automate → Secure → Report → Deploy |

> **Golden Rule of Salesforce:** Always try **declarative** (no-code) solutions first (Flows, Validation Rules). Only use **programmatic** solutions (Apex, LWC) when declarative can't meet the requirement.
```