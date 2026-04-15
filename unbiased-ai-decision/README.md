# Unbiased AI Decision

AI fairness auditing for automated decisions in hiring, lending, and care delivery.

![SDG 10](https://img.shields.io/badge/SDG%2010-Reduced%20Inequalities-009EDB?style=for-the-badge)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Vertex AI](https://img.shields.io/badge/Vertex%20AI-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)
![Gemini](https://img.shields.io/badge/Gemini-8E75FF?style=for-the-badge&logo=googlebard&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![SHAP](https://img.shields.io/badge/SHAP-Explainability-EF4444?style=for-the-badge)
![Causal AI](https://img.shields.io/badge/Causal%20AI-Enabled-111827?style=for-the-badge)

## SDG Target 10.3 — Equal Opportunity

Primary alignment: **SDG 10 — Reduced Inequalities**
Target 10.3 — **Ensure equal opportunity and reduce inequalities of outcome, including by eliminating discriminatory laws, policies, and practices**

## Live Demo

- Backend target URL: [https://your-cloud-run-url.run.app](https://your-cloud-run-url.run.app)
- Flutter web target URL: [https://your-cloud-run-url.run.app](https://your-cloud-run-url.run.app)

## Try The Demo

1. Open the Flutter app.
2. Tap **Try as Guest — no sign-up needed**.
3. The app signs in with Firebase Anonymous Authentication.
4. It immediately loads Firestore document `sample_hiring_audit`.
5. Open the report to review the Gemini explanation, SHAP feature impact, and SDG 10.3 badge.

## Project Structure

```text
unbiased-ai-decision/
├── backend/
├── flutter-app/
├── user-tests/
├── docker/
├── .env.example
├── video_script.md
├── IMPACT_STORY.md
└── README.md
```

## Architecture

```text
          +----------------------+
          | Flutter Mobile / Web |
          | Google / Guest Auth  |
          +----------+-----------+
                     |
                     v
             +-------+--------+
             | FastAPI Backend |
             | /audit /health  |
             +-------+--------+
                     |
     +---------------+-----------------+
     |                                 |
     v                                 v
+----+----------------+       +--------+---------+
| Gemini 1.5 Flash    |       | Vertex AI Job    |
| plain-language      |       | orchestration    |
| explanation         |       | + local analyzer |
+----+----------------+       +--------+---------+
     |                                 |
     +---------------+-----------------+
                     |
                     v
              +------+------+
              | Firestore   |
              | audit store |
              +-------------+
```

## Setup

1. Clone the repository.
2. Copy `.env.example` to `.env` and fill in Firebase, Vertex AI, and Gemini values.
3. From the project root, run:

   ```bash
   cd docker
   docker-compose up --build
   ```

4. Backend runs at [http://localhost:8080](http://localhost:8080)
5. Flutter web runs at [http://localhost:3000](http://localhost:3000)
6. Seed the guest demo audit:

   ```bash
   python backend/seed_sample_audit.py
   ```

## Cloud Run Deployment

```bash
gcloud builds submit --tag gcr.io/PROJECT_ID/unbiased-ai
gcloud run deploy unbiased-ai \
  --image gcr.io/PROJECT_ID/unbiased-ai \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars GEMINI_API_KEY=...,FIREBASE_...=...
```

After deployment, copy the generated Cloud Run URL into `.env`, Flutter build args, and the **Live Demo** section above.

## Backend API

- `GET /health`
- `POST /audit`
- `GET /audit/{audit_id}`
- `GET /audit/history/{user_id}`
- `POST /auth/verify`
- `GET /auth/me`

## User Test Evidence

- [User Test 1 — Recruiter workflow](user-tests/test_1_recruiter_tool.md)
- [User Test 2 — Loan approval workflow](user-tests/test_2_loan_model.md)
- [User Test 3 — Medical triage workflow](user-tests/test_3_medical_triage.md)

## Video Script And Demo

- [Problem statement video script](video_script.md)
- Demo video link: add the final unlisted YouTube URL after recording the scripted walkthrough

## SDG Alignment

The app displays the SDG marker everywhere an audit result appears:

- Flutter report screen shows **SDG 10 — Reduced Inequalities**
- Firestore audit documents store `sdg_tag: "SDG 10.3"`
- Gemini explanations reference SDG 10.3 for severe findings
- User test evidence ties each workflow back to equal opportunity outcomes
- The impact narrative explains why Target 10.3 is the right benchmark

## Community Impact Story

- [Read the impact narrative](IMPACT_STORY.md)

## Future Roadmap

- CI/CD bias gates for model release approval
- Multi-language support for policy and compliance teams
- Government API integrations for regulated decision audits
- Real-time monitoring dashboard for production fairness drift
