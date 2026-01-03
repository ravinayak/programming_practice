# Complete RAG (Retrieval Augmented Generation) Guide

## Table of Contents
1. [Week 1: Foundations of RAG](#week-1-foundations-of-rag)
2. [Week 2: Chunking, Embeddings, and Evaluation](#week-2-chunking-embeddings-and-evaluation)
3. [Week 3: Advanced Retrieval Architectures](#week-3-advanced-retrieval-architectures)
4. [Week 4: Mastering Evaluation](#week-4-mastering-evaluation)
5. [Week 5: Production Engineering & Optimization](#week-5-production-engineering--optimization)
6. [Week 6: Advanced Architectures & Deployment](#week-6-advanced-architectures--deployment)

---

## Week 1: Foundations of RAG

### 1. LLM Fundamentals: How LLMs Are Born (Pretraining)

#### What is Pretraining?

Pretraining is the initial phase where Large Language Models (LLMs) learn from vast amounts of text data to understand language patterns, grammar, facts, and reasoning.

#### Pretraining Process Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        LLM PRETRAINING PIPELINE                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA COLLECTION                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │   Web Text   │  │   Books      │  │   Code       │  │   Articles   │   │
│  │   (Common    │  │   (Literature│  │   (GitHub,   │  │   (Wikipedia,│   │
│  │   Crawl)     │  │   Corpus)    │  │   StackOverflow)│  │   News)     │   │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘   │
│         │                  │                  │                  │           │
│         └──────────────────┼──────────────────┼──────────────────┘           │
│                            │                  │                                │
│                            ▼                  ▼                                │
│                    ┌───────────────────────────────┐                         │
│                    │   Data Preprocessing           │                         │
│                    │   - Cleaning                  │                         │
│                    │   - Deduplication             │                         │
│                    │   - Tokenization              │                         │
│                    │   - Quality Filtering         │                         │
│                    └───────────────┬───────────────┘                         │
│                                    │                                         │
└────────────────────────────────────┼─────────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        NEURAL NETWORK ARCHITECTURE                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │                    Transformer Architecture                          │   │
│  │                                                                      │   │
│  │  Input Tokens: ["The", "cat", "sat", "on", "the", "mat"]            │   │
│  │       │                                                              │   │
│  │       ▼                                                              │   │
│  │  ┌──────────────────────────────────────────────────────────────┐  │   │
│  │  │  Token Embeddings + Positional Encoding                        │  │   │
│  │  └───────────────────────┬──────────────────────────────────────┘  │   │
│  │                          │                                          │   │
│  │                          ▼                                          │   │
│  │  ┌──────────────────────────────────────────────────────────────┐  │   │
│  │  │  Multi-Head Self-Attention Layers (N layers)                 │  │   │
│  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                   │  │   │
│  │  │  │  Layer 1 │→ │  Layer 2 │→ │  Layer N │                   │  │   │
│  │  │  └──────────┘  └──────────┘  └──────────┘                   │  │   │
│  │  │  Each layer:                                                  │  │   │
│  │  │  - Self-Attention (Q, K, V)                                  │  │   │
│  │  │  - Feed-Forward Network                                       │  │   │
│  │  │  - Layer Normalization                                        │  │   │
│  │  │  - Residual Connections                                       │  │   │
│  │  └───────────────────────┬──────────────────────────────────────┘  │   │
│  │                          │                                          │   │
│  │                          ▼                                          │   │
│  │  ┌──────────────────────────────────────────────────────────────┐  │   │
│  │  │  Output Embeddings (Contextual Representations)             │  │   │
│  │  └──────────────────────────────────────────────────────────────┘  │   │
│  │                                                                      │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          TRAINING PROCESS                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Objective: Predict next token given previous tokens                        │
│                                                                              │
│  Example:                                                                    │
│    Input:  "The cat sat on the"                                             │
│    Target: "mat"                                                             │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Loss Function: Cross-Entropy Loss                                  │   │
│  │  Optimizer: AdamW with Learning Rate Scheduling                     │   │
│  │  Training: Millions of GPUs for weeks/months                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

Key Concepts:
  • Self-Supervised Learning: Model learns from data without explicit labels
  • Next Token Prediction: Predicts the most likely next word
  • Context Window: Maximum sequence length the model can process
  • Parameters: Billions to trillions of learnable weights
```

### 2. LLM Fundamentals: Post-Training, Limitations, and Hallucinations

#### Post-Training Pipeline

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    LLM POST-TRAINING PIPELINE                                │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: PRETRAINED MODEL                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Base Model (GPT, LLaMA, etc.)                                      │   │
│  │  - Learned general language patterns                                 │   │
│  │  - Can generate text but not task-specific                           │   │
│  │  - May produce harmful or incorrect outputs                          │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
└──────────────────────────┼───────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: SUPERVISED FINE-TUNING (SFT)                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Training Data: (Input, Output) pairs                              │   │
│  │                                                                      │   │
│  │  Example:                                                           │   │
│  │    Input:  "Translate to French: Hello"                            │   │
│  │    Output: "Bonjour"                                                │   │
│  │                                                                      │   │
│  │    Input:  "Summarize: [long article]"                              │   │
│  │    Output: "[concise summary]"                                       │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
│                          ▼                                                   │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Fine-Tuned Model                                                   │   │
│  │  - Better at specific tasks                                        │   │
│  │  - More aligned with desired behavior                              │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
└──────────────────────────┼───────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: REINFORCEMENT LEARNING (RLHF)                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Reward Model Training                                              │   │
│  │  - Human feedback on model outputs                                  │   │
│  │  - Learns what humans prefer                                        │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
│                          ▼                                                   │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Policy Optimization (PPO)                                         │   │
│  │  - Model generates outputs                                         │   │
│  │  - Reward model scores them                                        │   │
│  │  - Model learns to maximize reward                                 │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
│                          ▼                                                   │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Aligned Model                                                     │   │
│  │  - Helpful, harmless, honest                                       │   │
│  │  - Better user experience                                         │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### LLM Limitations and Hallucinations

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    LLM LIMITATIONS & HALLUCINATIONS                          │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                        1. KNOWLEDGE CUTOFF                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Training Data Timeline                                            │   │
│  │                                                                      │   │
│  │  ────────────────────────────────────────────────────────────────  │   │
│  │  │                                                              │   │
│  │  │  All training data                                           │   │
│  │  │  (up to cutoff date)                                         │   │
│  │  │                                                              │   │
│  │  ────────────────────────────────────────────────────────────────  │   │
│  │  │                                                              │   │
│  │  │  Events after cutoff date                                   │   │
│  │  │  → Model doesn't know                                        │   │
│  │  │                                                              │   │
│  │  ────────────────────────────────────────────────────────────────  │   │
│  │                                                                      │   │
│  │  Example: GPT-4 trained on data up to April 2023                   │   │
│  │  → Cannot answer questions about events after that date            │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                        2. HALLUCINATIONS                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Types of Hallucinations:                                           │   │
│  │                                                                      │   │
│  │  a) Factual Hallucination:                                          │   │
│  │     User: "When was the iPhone 15 released?"                        │   │
│  │     Model: "The iPhone 15 was released in September 2022"            │   │
│  │     Reality: iPhone 15 released in September 2023                   │   │
│  │                                                                      │   │
│  │  b) Coherent but Incorrect:                                         │   │
│  │     Model generates plausible-sounding but false information        │   │
│  │                                                                      │   │
│  │  c) Citation Hallucination:                                         │   │
│  │     Model cites non-existent papers or sources                     │   │
│  │                                                                      │   │
│  │  Root Causes:                                                       │   │
│  │  - Training data contains errors                                   │   │
│  │  - Model overgeneralizes                                           │   │
│  │  - No grounding in real-time facts                                 │   │
│  │  - Statistical patterns vs. truth                                 │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                        3. CONTEXT WINDOW LIMITATIONS                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Context Window: Maximum tokens model can process                   │   │
│  │                                                                      │   │
│  │  GPT-3.5:     4K tokens  (~3,000 words)                            │   │
│  │  GPT-4:       8K tokens  (~6,000 words)                              │   │
│  │  GPT-4 Turbo: 128K tokens (~96,000 words)                            │   │
│  │  Claude 3:    200K tokens (~150,000 words)                          │   │
│  │                                                                      │   │
│  │  Problem: Cannot process documents longer than context window       │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                        4. COMPUTATIONAL COST                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Inference Cost Factors:                                           │   │
│  │                                                                      │   │
│  │  - Model Size: Larger models = more expensive                       │   │
│  │  - Context Length: Longer inputs = more computation                 │   │
│  │  - Token Generation: Each token requires forward pass               │   │
│  │                                                                      │   │
│  │  Example Costs (GPT-4):                                             │   │
│  │  - Input:  $0.03 per 1K tokens                                      │   │
│  │  - Output: $0.06 per 1K tokens                                      │   │
│  │                                                                      │   │
│  │  For 1M users × 10 queries/day = $600-1200/day                     │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3. The RAG Paradigm: Architecture and Core Components

#### RAG Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        RAG ARCHITECTURE DIAGRAM                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              USER QUERY                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  User: "What are the side effects of medication X?"                         │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         QUERY PROCESSING                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Query Preprocessing                                                │   │
│  │  - Normalization                                                    │   │
│  │  - Query expansion (optional)                                       │   │
│  │  - Query understanding                                              │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
│                          ▼                                                   │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Query Embedding                                                     │   │
│  │  - Convert query to vector using embedding model                    │   │
│  │  - Example: "side effects medication X" → [0.23, -0.45, 0.67, ...]  │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
└──────────────────────────┼───────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         RETRIEVAL LAYER                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Vector Database (e.g., Qdrant, Pinecone, Weaviate)               │   │
│  │                                                                      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │   │
│  │  │  Document 1  │  │  Document 2  │  │  Document 3  │              │   │
│  │  │  Vector:     │  │  Vector:     │  │  Vector:     │              │   │
│  │  │  [0.1, 0.2,  │  │  [0.3, 0.1,  │  │  [0.2, 0.4,  │              │   │
│  │  │   0.5, ...]  │  │   0.6, ...]  │  │   0.3, ...]  │              │   │
│  │  │              │  │              │  │              │              │   │
│  │  │  Text: "..." │  │  Text: "..." │  │  Text: "..." │              │   │
│  │  │  Metadata:   │  │  Metadata:   │  │  Metadata:   │              │   │
│  │  │  {source,    │  │  {source,    │  │  {source,    │              │   │
│  │  │   date, ...} │  │   date, ...}  │  │   date, ...}  │              │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘              │   │
│  │                                                                      │   │
│  │  Similarity Search (Cosine Similarity / Dot Product)                │   │
│  │  → Returns top K most similar documents                             │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
│                          ▼                                                   │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Retrieved Context                                                  │   │
│  │  - Top K relevant document chunks                                   │   │
│  │  - Ranked by similarity score                                      │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
└──────────────────────────┼───────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         GENERATION LAYER                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Prompt Construction                                                │   │
│  │                                                                      │   │
│  │  System Prompt:                                                     │   │
│  │  "You are a helpful assistant. Answer based on the provided context."│   │
│  │                                                                      │   │
│  │  Context:                                                           │   │
│  │  [Retrieved Document 1]                                            │   │
│  │  [Retrieved Document 2]                                             │   │
│  │  [Retrieved Document 3]                                             │   │
│  │                                                                      │   │
│  │  User Query: "What are the side effects of medication X?"          │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
│                          ▼                                                   │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  LLM (GPT-4, Claude, etc.)                                          │   │
│  │  - Processes prompt with context                                    │   │
│  │  - Generates answer grounded in retrieved documents                │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
│                          ▼                                                   │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Final Answer                                                       │   │
│  │  "Based on the medical literature, medication X may cause:         │   │
│  │   - Nausea                                                          │   │
│  │   - Headaches                                                       │   │
│  │   - Dizziness                                                       │   │
│  │   [with citations to source documents]"                             │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### RAG vs. Fine-Tuning Comparison

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RAG vs. FINE-TUNING COMPARISON                           │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         FINE-TUNING APPROACH                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Base Model                                                         │   │
│  │  └──────┬───────────────────────────────────────────────────────┘  │   │
│  │         │                                                           │   │
│  │         ▼                                                           │   │
│  │  ┌──────────────────────────────────────────────────────────────┐  │   │
│  │  │  Training Data (Domain-Specific)                             │   │
│  │  │  - Requires labeled examples                                  │   │
│  │  │  - Expensive to create                                        │   │
│  │  │  - Time-consuming                                             │   │
│  │  └──────┬───────────────────────────────────────────────────────┘  │   │
│  │         │                                                           │   │
│  │         ▼                                                           │   │
│  │  ┌──────────────────────────────────────────────────────────────┐  │   │
│  │  │  Fine-Tuned Model                                              │   │
│  │  │  - Model weights updated                                      │   │
│  │  │  - Knowledge "baked in"                                        │   │
│  │  │  - Cannot update without retraining                            │   │
│  │  └──────────────────────────────────────────────────────────────┘  │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Model understands domain deeply                                 │   │
│  │  ✓ Fast inference (no retrieval step)                              │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ Expensive to train                                              │   │
│  │  ✗ Hard to update knowledge                                       │   │
│  │  ✗ Risk of catastrophic forgetting                                │   │
│  │  ✗ Limited to training data                                       │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         RAG APPROACH                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Base Model (Unchanged)                                             │   │
│  │  └──────┬───────────────────────────────────────────────────────┘  │   │
│  │         │                                                           │   │
│  │         ▼                                                           │   │
│  │  ┌──────────────────────────────────────────────────────────────┐  │   │
│  │  │  External Knowledge Base                                       │   │
│  │  │  - Documents, databases, APIs                                 │   │
│  │  │  - Easy to update                                             │   │
│  │  │  - No retraining needed                                       │   │
│  │  └──────┬───────────────────────────────────────────────────────┘  │   │
│  │         │                                                           │   │
│  │         ▼                                                           │   │
│  │  ┌──────────────────────────────────────────────────────────────┐  │   │
│  │  │  RAG System                                                    │   │
│  │  │  - Retrieves relevant context                                 │   │
│  │  │  - Augments LLM with context                                   │   │
│  │  │  - Generates grounded answers                                  │   │
│  │  └──────────────────────────────────────────────────────────────┘  │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Easy to update knowledge (just update documents)                │   │
│  │  ✓ Can cite sources                                                │   │
│  │  ✓ Works with any LLM                                              │   │
│  │  ✓ Lower cost (no retraining)                                     │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ Requires retrieval step (adds latency)                        │   │
│  │  ✗ Quality depends on retrieval accuracy                           │   │
│  │  ✗ Context window limits                                           │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4. Framework: How to Identify, Qualify, and Define Your RAG Project

#### RAG Project Framework

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RAG PROJECT FRAMEWORK                                    │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: IDENTIFY USE CASE                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Questions to Ask:                                                          │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  1. What problem are you solving?                                  │   │
│  │     - Customer support?                                            │   │
│  │     - Internal knowledge base?                                      │   │
│  │     - Document Q&A?                                                │   │
│  │     - Code search?                                                 │   │
│  │                                                                      │   │
│  │  2. What data sources do you have?                                  │   │
│  │     - PDFs, Word docs, HTML pages?                                 │   │
│  │     - Databases, APIs?                                             │   │
│  │     - Structured vs. unstructured?                                 │   │
│  │                                                                      │   │
│  │  3. Who are your users?                                            │   │
│  │     - Internal employees?                                         │   │
│  │     - External customers?                                          │   │
│  │     - Technical vs. non-technical?                                 │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: QUALIFY THE PROJECT                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  RAG Suitability Checklist:                                         │   │
│  │                                                                      │   │
│  │  ✓ Knowledge is document-based                                      │   │
│  │  ✓ Information changes frequently                                   │   │
│  │  ✓ Need for source citations                                        │   │
│  │  ✓ Domain-specific knowledge required                               │   │
│  │  ✓ Multiple data sources                                            │   │
│  │                                                                      │   │
│  │  ✗ Real-time data required (use APIs instead)                       │   │
│  │  ✗ Simple rule-based logic (use traditional systems)               │   │
│  │  ✗ Highly structured data (use SQL/databases)                      │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: DEFINE REQUIREMENTS                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Performance Requirements:                                          │   │
│  │                                                                      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │   │
│  │  │  Accuracy    │  │  Latency     │  │  Cost        │            │   │
│  │  │              │  │              │  │              │            │   │
│  │  │  Target:     │  │  Target:     │  │  Target:     │            │   │
│  │  │  > 85%       │  │  < 2s        │  │  < $0.01/    │            │   │
│  │  │  relevance   │  │  end-to-end   │  │  query       │            │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘            │   │
│  │                                                                      │   │
│  │  Data Requirements:                                                 │   │
│  │  - Volume: How many documents?                                      │   │
│  │  - Format: PDF, HTML, Markdown, etc.?                             │   │
│  │  - Update frequency: Daily, weekly, real-time?                      │   │
│  │  - Quality: Clean, structured, or messy?                           │   │
│  │                                                                      │   │
│  │  User Requirements:                                                 │   │
│  │  - Expected query types                                             │   │
│  │  - Language(s)                                                      │   │
│  │  - Technical level                                                  │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5. Setting Up Your Production Stack: Qdrant, Haystack, and Gemini

#### Production RAG Stack Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    PRODUCTION RAG STACK                                     │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         DATA INGESTION                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                    │
│  │   PDFs       │  │   Web Pages  │  │   Databases   │                    │
│  │   Documents  │  │   HTML       │  │   APIs        │                    │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘                    │
│         │                  │                  │                             │
│         └──────────────────┼──────────────────┘                             │
│                            │                                                 │
│                            ▼                                                 │
│  ┌────────────────────────────────────────────────────────────────────┐     │
│  │  Haystack Pipeline                                                 │     │
│  │  - Document Preprocessor                                           │     │
│  │  - Text Splitter (Chunking)                                        │     │
│  │  - Embedding Generator                                             │     │
│  └───────────────────────┬──────────────────────────────────────────────┘     │
│                          │                                                   │
└──────────────────────────┼───────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         VECTOR DATABASE                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Qdrant Vector Database                                            │   │
│  │                                                                      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │   │
│  │  │  Collection  │  │  Collection  │  │  Collection  │            │   │
│  │  │  "docs"     │  │  "code"       │  │  "faq"       │            │   │
│  │  │             │  │              │  │              │            │   │
│  │  │  Vectors:   │  │  Vectors:    │  │  Vectors:    │            │   │
│  │  │  [1536-dim] │  │  [1536-dim]  │  │  [1536-dim]  │            │   │
│  │  │             │  │              │  │              │            │   │
│  │  │  Metadata:  │  │  Metadata:   │  │  Metadata:   │            │   │
│  │  │  - source   │  │  - file_path │  │  - category  │            │   │
│  │  │  - date     │  │  - language  │  │  - priority  │            │   │
│  │  │  - author   │  │  - function  │  │              │            │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘            │   │
│  │                                                                      │   │
│  │  Features:                                                           │   │
│  │  - HNSW indexing for fast similarity search                        │   │
│  │  - Metadata filtering                                               │   │
│  │  - Horizontal scaling                                               │   │
│  │  - REST API                                                         │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
└──────────────────────────┼───────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         RETRIEVAL & GENERATION                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Haystack Retrieval Pipeline                                       │   │
│  │                                                                      │   │
│  │  1. Query Embedding (using embedding model)                        │   │
│  │  2. Vector Search (Qdrant)                                          │   │
│  │  3. Reranking (optional)                                           │   │
│  │  4. Context Assembly                                                │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
│                          ▼                                                   │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Google Gemini API                                                  │   │
│  │  - Receives query + context                                        │   │
│  │  - Generates answer                                                 │   │
│  │  - Returns response with citations                                  │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
└──────────────────────────┼───────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         API LAYER                                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  FastAPI Backend                                                   │   │
│  │  - REST endpoints                                                  │   │
│  │  - Authentication                                                   │   │
│  │  - Rate limiting                                                    │   │
│  │  - Logging & monitoring                                            │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 6. Hands-On: Building Your First End-to-End RAG Pipeline

#### End-to-End RAG Pipeline Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    END-TO-END RAG PIPELINE                                  │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    PHASE 1: DATA PREPARATION                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Step 1: Load Documents                                                     │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  from haystack import Document                                      │   │
│  │                                                                      │   │
│  │  documents = []                                                      │   │
│  │  for file in pdf_files:                                              │   │
│  │      text = extract_text(file)                                      │   │
│  │      doc = Document(content=text, meta={"source": file})            │   │
│  │      documents.append(doc)                                           │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 2: Chunk Documents                                                     │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  from haystack.components.preprocessors import DocumentSplitter     │   │
│  │                                                                      │   │
│  │  splitter = DocumentSplitter(split_by="sentence",                   │   │
│  │                             split_length=200)                       │   │
│  │  chunks = splitter.run(documents=documents)                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 3: Generate Embeddings                                                 │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  from haystack.components.embedders import OpenAIDocumentEmbedder   │   │
│  │                                                                      │   │
│  │  embedder = OpenAIDocumentEmbedder(api_key=api_key)                │   │
│  │  embedded_chunks = embedder.run(documents=chunks)                  │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 4: Store in Vector DB                                                 │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  from haystack_integrations.components.vectorstores import QdrantDocumentStore│   │
│  │                                                                      │   │
│  │  document_store = QdrantDocumentStore(                              │   │
│  │      url="http://localhost:6333",                                    │   │
│  │      index="documents"                                               │   │
│  │  )                                                                   │   │
│  │  document_store.write_documents(embedded_chunks)                     │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    PHASE 2: QUERY PROCESSING                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Step 1: User Query                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  query = "What are the side effects of medication X?"               │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 2: Embed Query                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  from haystack.components.embedders import OpenAIQueryEmbedder     │   │
│  │                                                                      │   │
│  │  query_embedder = OpenAIQueryEmbedder(api_key=api_key)              │   │
│  │  query_embedding = query_embedder.run(query=query)                 │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 3: Retrieve Relevant Documents                                        │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  from haystack.components.retrievers import InMemoryEmbeddingRetriever│   │
│  │                                                                      │   │
│  │  retriever = InMemoryEmbeddingRetriever(                            │   │
│  │      document_store=document_store,                                 │   │
│  │      top_k=5                                                        │   │
│  │  )                                                                   │   │
│  │  retrieved_docs = retriever.run(query_embedding=query_embedding)   │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    PHASE 3: ANSWER GENERATION                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Step 1: Construct Prompt                                                    │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  context = "\n\n".join([doc.content for doc in retrieved_docs])   │   │
│  │                                                                      │   │
│  │  prompt = f"""                                                       │   │
│  │  Context: {context}                                                │   │
│  │                                                                      │   │
│  │  Question: {query}                                                  │   │
│  │                                                                      │   │
│  │  Answer based on the context above:                                │   │
│  │  """                                                                │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 2: Generate Answer                                                     │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  from haystack.components.generators import OpenAIGenerator        │   │
│  │                                                                      │   │
│  │  generator = OpenAIGenerator(api_key=api_key, model="gpt-4")        │   │
│  │  answer = generator.run(prompt=prompt)                             │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 3: Return Response                                                    │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  response = {                                                      │   │
│  │      "answer": answer["replies"][0],                               │   │
│  │      "sources": [doc.meta["source"] for doc in retrieved_docs],  │   │
│  │      "confidence": answer["meta"]["score"]                         │   │
│  │  }                                                                 │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 7. Testing and Debugging Your Initial Queries

#### RAG Testing Framework

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RAG TESTING & DEBUGGING FRAMEWORK                        │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    TESTING STRATEGY                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  1. Unit Testing                                                   │   │
│  │                                                                      │   │
│  │     Test Individual Components:                                    │   │
│  │     - Document loading                                              │   │
│  │     - Chunking logic                                                │   │
│  │     - Embedding generation                                          │   │
│  │     - Vector search                                                 │   │
│  │                                                                      │   │
│  │     Example:                                                        │   │
│  │     def test_chunking():                                            │   │
│  │         doc = Document(content="Long text...")                     │   │
│  │         chunks = splitter.run(documents=[doc])                    │   │
│  │         assert len(chunks) > 1                                     │   │
│  │         assert all(len(c.content) <= max_length for c in chunks)  │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  2. Integration Testing                                            │   │
│  │                                                                      │   │
│  │     Test End-to-End Flow:                                           │   │
│  │     - Query → Retrieval → Generation                                │   │
│  │     - Verify retrieved documents are relevant                      │   │
│  │     - Verify answer quality                                        │   │
│  │                                                                      │   │
│  │     Example Test Cases:                                             │   │
│  │     ┌──────────────────────────────────────────────────────────┐   │   │
│  │     │ Query: "What is X?"                                      │   │   │
│  │     │ Expected: Retrieved docs contain information about X      │   │   │
│  │     │ Expected: Answer mentions X                               │   │   │
│  │     └──────────────────────────────────────────────────────────┘   │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  3. Evaluation Metrics                                             │   │
│  │                                                                      │   │
│  │     ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │   │
│  │     │  Retrieval   │  │  Generation  │  │  End-to-End  │          │   │
│  │     │  Metrics     │  │  Metrics     │  │  Metrics      │          │   │
│  │     │              │  │              │  │              │          │   │
│  │     │ - Precision  │  │ - BLEU       │  │ - Accuracy   │          │   │
│  │     │ - Recall     │  │ - ROUGE      │  │ - Relevance  │          │   │
│  │     │ - MRR        │  │ - Semantic   │  │ - User       │          │   │
│  │     │ - NDCG       │  │   Similarity  │  │   Satisfaction│          │   │
│  │     └──────────────┘  └──────────────┘  └──────────────┘          │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    DEBUGGING TECHNIQUES                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Common Issues & Solutions:                                         │   │
│  │                                                                      │   │
│  │  1. Poor Retrieval Quality                                          │   │
│  │     Symptoms:                                                       │   │
│  │     - Retrieved docs not relevant to query                         │   │
│  │     - Missing important documents                                  │   │
│  │                                                                      │   │
│  │     Debugging:                                                      │   │
│  │     - Check embedding similarity scores                            │   │
│  │     - Verify query embedding matches document embeddings          │   │
│  │     - Try different chunking strategies                           │   │
│  │     - Adjust top_k parameter                                       │   │
│  │                                                                      │   │
│  │  2. Hallucinated Answers                                            │   │
│  │     Symptoms:                                                       │   │
│  │     - Answer not in retrieved context                              │   │
│  │     - Model makes up information                                  │   │
│  │                                                                      │   │
│  │     Debugging:                                                      │   │
│  │     - Add prompt instructions: "Only use provided context"        │   │
│  │     - Verify context is being passed correctly                    │   │
│  │     - Check if retrieved docs actually contain answer             │   │
│  │                                                                      │   │
│  │  3. Slow Response Times                                             │   │
│  │     Symptoms:                                                       │   │
│  │     - Query takes > 5 seconds                                      │   │
│  │                                                                      │   │
│  │     Debugging:                                                      │   │
│  │     - Profile each component (embedding, retrieval, generation)   │   │
│  │     - Use faster embedding models                                  │   │
│  │     - Reduce top_k                                                │   │
│  │     - Implement caching                                            │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Week 2: Chunking, Embeddings, and Evaluation

### 1. Why Chunking Is Your Most Important Decision

#### Chunking Impact on RAG Performance

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CHUNKING IMPACT DIAGRAM                                   │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    POOR CHUNKING → POOR RESULTS                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Document: 10,000 words                                                     │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Chunk Size: 10,000 words (entire document)                       │   │
│  │                                                                      │   │
│  │  Problems:                                                          │   │
│  │  ✗ Too large → Context dilution                                   │   │
│  │  ✗ Embedding represents entire doc (not specific info)           │   │
│  │  ✗ Low precision in retrieval                                     │   │
│  │  ✗ High computational cost                                       │   │
│  │                                                                      │   │
│  │  Query: "What is the dosage for medication X?"                    │   │
│  │  → Retrieves entire document (10K words)                          │   │
│  │  → Answer buried in large context                                 │   │
│  │  → LLM may miss specific information                              │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Chunk Size: 50 words (too small)                                  │   │
│  │                                                                      │   │
│  │  Problems:                                                          │   │
│  │  ✗ Too small → Loss of context                                    │   │
│  │  ✗ Information fragmented                                          │   │
│  │  ✗ Missing relationships between concepts                          │   │
│  │  ✗ Many chunks needed to answer one question                      │   │
│  │                                                                      │   │
│  │  Query: "Explain the mechanism of action"                          │   │
│  │  → Retrieves multiple tiny chunks                                  │   │
│  │  → Missing connections between concepts                            │   │
│  │  → Incomplete answer                                               │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    OPTIMAL CHUNKING → GOOD RESULTS                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Document: 10,000 words                                                     │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Chunk Size: 200-500 words (semantic units)                       │   │
│  │                                                                      │   │
│  │  Benefits:                                                          │   │
│  │  ✓ Right size → Preserves context                                  │   │
│  │  ✓ Embedding captures semantic meaning                            │   │
│  │  ✓ High precision in retrieval                                     │   │
│  │  ✓ Balanced computational cost                                    │   │
│  │                                                                      │   │
│  │  Query: "What is the dosage for medication X?"                    │   │
│  │  → Retrieves relevant chunk (200-500 words)                       │   │
│  │  → Chunk contains complete dosage information                      │   │
│  │  → LLM can extract precise answer                                  │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

Chunking Strategy Decision Tree:
  ┌─────────────────────────────────────────────────────────────┐
  │  What type of content?                                       │
  │  ├─ Technical docs → 300-500 words                          │
  │  ├─ Conversational → 200-300 words                          │
  │  ├─ Code → Function/class level                              │
  │  └─ Structured data → Table/row level                      │
  │                                                              │
  │  What is the query pattern?                                  │
  │  ├─ Factual Q&A → Smaller chunks (200-300)                 │
  │  ├─ Explanatory → Larger chunks (400-600)                   │
  │  └─ Comparative → Medium chunks (300-400)                   │
  └─────────────────────────────────────────────────────────────┘
```

### 2. Embeddings Deep Dive: How Text Becomes Vectors

#### Embedding Generation Process

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TEXT TO VECTOR EMBEDDING PIPELINE                         │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 1: TEXT INPUT                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Input Text: "The cat sat on the mat"                                       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 2: TOKENIZATION                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Text → Tokens                                                             │
│                                                                              │
│  "The cat sat on the mat"                                                   │
│  → ["The", "cat", "sat", "on", "the", "mat"]                               │
│                                                                              │
│  (Using tokenizer: BPE, WordPiece, SentencePiece, etc.)                     │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 3: TOKEN EMBEDDINGS                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Each token → Dense vector (e.g., 768 dimensions)                         │
│                                                                              │
│  "The"  → [0.12, -0.45, 0.67, ..., 0.23]  (768-dim vector)                │
│  "cat"  → [0.34, 0.12, -0.56, ..., 0.45]  (768-dim vector)                │
│  "sat"  → [-0.23, 0.78, 0.12, ..., -0.34] (768-dim vector)                │
│  ...                                                                        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 4: CONTEXTUAL ENCODING                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Transformer Encoder (BERT, Sentence-BERT, etc.)                           │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Input: Token Embeddings + Position Embeddings                      │   │
│  │       │                                                              │   │
│  │       ▼                                                              │   │
│  │  Multi-Head Self-Attention                                           │   │
│  │  - Each token attends to all other tokens                           │   │
│  │  - Captures context and relationships                               │   │
│  │       │                                                              │   │
│  │       ▼                                                              │   │
│  │  Contextual Token Representations                                    │   │
│  │  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STEP 5: POOLING (Sentence Embedding)                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Aggregate token embeddings → Single sentence embedding                    │
│                                                                              │
│  Methods:                                                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                      │
│  │  Mean Pooling│  │  Max Pooling │  │  CLS Token  │                      │
│  │              │  │              │  │              │                      │
│  │  Average all │  │  Max across  │  │  Use special │                      │
│  │  token vecs  │  │  dimensions  │  │  [CLS] token │                      │
│  └──────────────┘  └──────────────┘  └──────────────┘                      │
│                                                                              │
│  Result:                                                                     │
│  "The cat sat on the mat" → [0.23, -0.12, 0.45, ..., 0.67] (768-dim)       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    EMBEDDING MODELS COMPARISON                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Model              │ Dimensions │ Speed │ Quality │ Use Case      │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  text-embedding-    │ 1536       │ Fast  │ High   │ General        │   │
│  │  ada-002 (OpenAI)   │            │       │        │                │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  text-embedding-3-  │ 3072       │ Fast  │ Very   │ High quality   │   │
│  │  large (OpenAI)    │            │       │ High  │                │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  sentence-transformers│ 384-768  │ Very  │ Good  │ Open source    │   │
│  │  (all-MiniLM-L6-v2) │            │ Fast  │        │                │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  Cohere embed-      │ 1024       │ Fast  │ High   │ Multilingual   │   │
│  │  multilingual-v3    │            │       │        │                │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3. A Deep Dive into Different Chunking Strategies

#### Chunking Strategies Comparison

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CHUNKING STRATEGIES OVERVIEW                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    1. FIXED-SIZE CHUNKING                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Split text into fixed-size chunks                       │   │
│  │                                                                      │   │
│  │  Example:                                                           │   │
│  │  Text: "This is a long document with many sentences..."            │   │
│  │                                                                      │   │
│  │  Chunk 1: "This is a long document with many sentences. Here is    │   │
│  │            another sentence. And yet another one." (100 chars)     │   │
│  │                                                                      │   │
│  │  Chunk 2: "More text continues here. This is the second chunk.     │   │
│  │            Keep going with more content." (100 chars)              │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Simple to implement                                             │   │
│  │  ✓ Predictable chunk sizes                                         │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ May split sentences mid-way                                      │   │
│  │  ✗ Loses semantic coherence                                        │   │
│  │  ✗ Context may be fragmented                                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    2. SENTENCE-BASED CHUNKING                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Split by sentences, group into chunks                    │   │
│  │                                                                      │   │
│  │  Example:                                                           │   │
│  │  Text: "Sentence 1. Sentence 2. Sentence 3. Sentence 4. Sentence 5."│   │
│  │                                                                      │   │
│  │  Chunk 1: "Sentence 1. Sentence 2. Sentence 3."                      │   │
│  │  Chunk 2: "Sentence 4. Sentence 5."                                 │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Preserves sentence boundaries                                    │   │
│  │  ✓ Better semantic coherence                                        │   │
│  │  ✓ Natural language units                                           │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ Variable chunk sizes                                              │   │
│  │  ✗ May need overlap for context                                      │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    3. RECURSIVE CHUNKING                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Recursively split by different separators                │   │
│  │                                                                      │   │
│  │  Hierarchy:                                                         │   │
│  │  1. Split by paragraphs (\n\n)                                     │   │
│  │  2. If chunk too large → Split by sentences (.)                    │   │
│  │  3. If still too large → Split by words                            │   │
│  │                                                                      │   │
│  │  Example:                                                           │   │
│  │  Document:                                                           │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  Paragraph 1 (500 words)                                        │ │   │
│  │  │  → Too large, split by sentences                               │ │   │
│  │  │  → Chunk 1: "Sentence 1-5" (200 words)                        │ │   │
│  │  │  → Chunk 2: "Sentence 6-10" (200 words)                        │ │   │
│  │  │  → Chunk 3: "Sentence 11-15" (100 words)                        │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Adapts to document structure                                      │   │
│  │  ✓ Preserves hierarchy                                              │   │
│  │  ✓ Handles variable content sizes                                  │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ More complex implementation                                      │   │
│  │  ✗ May still split important content                                │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    4. SLIDING WINDOW CHUNKING                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Overlapping chunks for context preservation               │   │
│  │                                                                      │   │
│  │  Example (chunk_size=200, overlap=50):                              │   │
│  │                                                                      │   │
│  │  Chunk 1: [0-200]                                                   │   │
│  │  Chunk 2: [150-350]  (overlaps with Chunk 1)                       │   │
│  │  Chunk 3: [300-500]  (overlaps with Chunk 2)                       │   │
│  │                                                                      │   │
│  │  Visual:                                                             │   │
│  │  ────────────────────────────────────────────────────────────────  │   │
│  │  [========Chunk 1========]                                          │   │
│  │          [========Chunk 2========]                                   │   │
│  │                    [========Chunk 3========]                         │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Preserves context across boundaries                              │   │
│  │  ✓ Reduces information loss at chunk edges                           │   │
│  │  ✓ Better for queries spanning multiple chunks                      │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ More chunks = more storage                                      │   │
│  │  ✗ Higher computational cost                                        │   │
│  │  ✗ Potential redundancy                                            │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4. Content-Aware Chunking: AST-based (Code) and Semantic Approaches

#### Content-Aware Chunking Strategies

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CONTENT-AWARE CHUNKING                                    │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    AST-BASED CHUNKING (FOR CODE)                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Use Abstract Syntax Tree to chunk code logically        │   │
│  │                                                                      │   │
│  │  Code Example:                                                      │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  def calculate_total(items):                                   │ │   │
│  │  │      total = 0                                                 │ │   │
│  │  │      for item in items:                                       │ │   │
│  │  │          total += item.price                                   │ │   │
│  │  │      return total                                              │ │   │
│  │  │                                                                 │ │   │
│  │  │  class ShoppingCart:                                           │ │   │
│  │  │      def __init__(self):                                       │ │   │
│  │  │          self.items = []                                       │ │   │
│  │  │      def add_item(self, item):                                 │ │   │
│  │  │          self.items.append(item)                               │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │                                                                      │   │
│  │  AST Structure:                                                     │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  Module                                                       │ │   │
│  │  │  ├─ FunctionDef: calculate_total                             │ │   │
│  │  │  │  └─ Chunk 1: Complete function                            │ │   │
│  │  │  └─ ClassDef: ShoppingCart                                    │ │   │
│  │  │     ├─ FunctionDef: __init__                                  │ │   │
│  │  │     │  └─ Chunk 2: Constructor method                          │ │   │
│  │  │     └─ FunctionDef: add_item                                  │ │   │
│  │  │        └─ Chunk 3: Method                                     │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │                                                                      │   │
│  │  Benefits:                                                           │   │
│  │  ✓ Preserves code structure                                        │   │
│  │  ✓ Chunks are syntactically complete                              │   │
│  │  ✓ Better for code search and understanding                       │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    SEMANTIC CHUNKING                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Use embeddings to find semantic boundaries               │   │
│  │                                                                      │   │
│  │  Process:                                                           │   │
│  │  1. Split text into sentences                                       │   │
│  │  2. Generate embeddings for each sentence                           │   │
│  │  3. Calculate similarity between adjacent sentences                │   │
│  │  4. Chunk where similarity drops (semantic shift)                  │   │
│  │                                                                      │   │
│  │  Example:                                                           │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  Sentence 1: "Introduction to machine learning..."            │ │   │
│  │  │  Sentence 2: "ML algorithms include..."                      │ │   │
│  │  │  Similarity: 0.85 (high - same topic)                        │ │   │
│  │  │  → Keep together                                              │ │   │
│  │  │                                                                │ │   │
│  │  │  Sentence 3: "Now let's discuss deep learning..."            │ │   │
│  │  │  Similarity: 0.82 (high - related topic)                     │ │   │
│  │  │  → Keep together                                              │ │   │
│  │  │                                                                │ │   │
│  │  │  Sentence 4: "The weather today is sunny..."                  │ │   │
│  │  │  Similarity: 0.15 (low - topic shift)                        │ │   │
│  │  │  → Create new chunk here                                       │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │                                                                      │   │
│  │  Benefits:                                                           │   │
│  │  ✓ Chunks are semantically coherent                                │   │
│  │  ✓ Adapts to content structure                                     │   │
│  │  ✓ Better retrieval quality                                        │   │
│  │                                                                      │   │
│  │  Tools:                                                             │   │
│  │  - LangChain SemanticChunker                                       │   │
│  │  - Custom similarity-based chunking                                │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5. Introduction to RAG Evaluation: LLM-as-a-Judge & Human Review

#### RAG Evaluation Framework

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RAG EVALUATION METHODS                                    │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    1. LLM-AS-A-JUDGE                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Use LLM to evaluate RAG outputs                        │   │
│  │                                                                      │   │
│  │  Evaluation Prompt:                                                │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  You are evaluating a RAG system response.                   │ │   │
│  │  │                                                                │ │   │
│  │  │  Query: {query}                                               │ │   │
│  │  │  Retrieved Context: {context}                               │ │   │
│  │  │  Generated Answer: {answer}                                   │ │   │
│  │  │                                                                │ │   │
│  │  │  Rate the answer on:                                          │ │   │
│  │  │  1. Relevance (1-5): Does it answer the query?                │ │   │
│  │  │  2. Accuracy (1-5): Is it factually correct?                │ │   │
│  │  │  3. Completeness (1-5): Does it cover all aspects?           │ │   │
│  │  │  4. Groundedness (1-5): Is it based on context?             │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Scalable (automated)                                            │   │
│  │  ✓ Fast evaluation                                                  │   │
│  │  ✓ Consistent criteria                                              │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ May have biases                                                 │   │
│  │  ✗ Cost of LLM API calls                                           │   │
│  │  ✗ Not perfect (may miss nuances)                                 │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    2. HUMAN REVIEW                                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Domain experts evaluate outputs                        │   │
│  │                                                                      │   │
│  │  Evaluation Criteria:                                              │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  1. Relevance: Does answer address the query?              │ │   │
│  │  │     - Fully relevant: 5                                      │ │   │
│  │  │     - Partially relevant: 3                                  │ │   │
│  │  │     - Not relevant: 1                                        │ │   │
│  │  │                                                                │ │   │
│  │  │  2. Accuracy: Is information correct?                        │ │   │
│  │  │     - All facts correct: 5                                   │ │   │
│  │  │     - Minor errors: 3                                         │ │   │
│  │  │     - Major errors: 1                                         │ │   │
│  │  │                                                                │ │   │
│  │  │  3. Completeness: Does it cover all aspects?                  │ │   │
│  │  │     - Comprehensive: 5                                        │ │   │
│  │  │     - Missing some info: 3                                    │ │   │
│  │  │     - Incomplete: 1                                            │ │   │
│  │  │                                                                │ │   │
│  │  │  4. Groundedness: Is it based on provided context?           │ │   │
│  │  │     - Fully grounded: 5                                       │ │   │
│  │  │     - Some hallucination: 3                                   │ │   │
│  │  │     - Mostly hallucinated: 1                                  │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Most accurate evaluation                                        │   │
│  │  ✓ Catches subtle issues                                           │   │
│  │  ✓ Domain expertise                                                │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ Expensive and time-consuming                                   │   │
│  │  ✗ Not scalable                                                    │   │
│  │  ✗ Subjective (inter-annotator agreement)                         │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    EVALUATION METRICS SUMMARY                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Metric Category        │ Metric Name        │ Range │ Best Use   │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  Retrieval              │ Precision@K         │ 0-1   │ Top-K docs │   │
│  │                         │ Recall@K            │ 0-1   │ Coverage   │   │
│  │                         │ MRR                 │ 0-1   │ Ranking    │   │
│  │                         │ NDCG                │ 0-1   │ Ranking    │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  Generation             │ BLEU                │ 0-1   │ Exact match│   │
│  │                         │ ROUGE               │ 0-1   │ Summaries │   │
│  │                         │ Semantic Similarity │ 0-1   │ Meaning    │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  End-to-End             │ Answer Relevance    │ 1-5   │ Quality   │   │
│  │                         │ Answer Correctness  │ 1-5   │ Accuracy  │   │
│  │                         │ Faithfulness        │ 1-5   │ Grounding │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 6. Hands-On: Systematically Comparing Strategies to Find a Winner

#### Strategy Comparison Framework

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CHUNKING STRATEGY COMPARISON                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    EXPERIMENTAL SETUP                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Test Dataset: 100 queries with ground truth answers                        │
│                                                                              │
│  Strategies to Compare:                                                      │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  1. Fixed-size (200 chars, no overlap)                             │   │
│  │  2. Sentence-based (3 sentences per chunk)                         │   │
│  │  3. Recursive (paragraph → sentence → word)                        │   │
│  │  4. Sliding window (200 chars, 50 char overlap)                     │   │
│  │  5. Semantic chunking (similarity threshold: 0.7)                   │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    EVALUATION PIPELINE                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  For each strategy:                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  1. Chunk documents using strategy                                 │   │
│  │  2. Generate embeddings for chunks                                 │   │
│  │  3. Store in vector database                                       │   │
│  │  4. Run queries through RAG pipeline                               │   │
│  │  5. Evaluate results:                                               │   │
│  │     - Retrieval metrics (Precision@5, Recall@5)                     │   │
│  │     - Answer quality (LLM-as-a-judge scores)                      │   │
│  │     - Latency (time per query)                                     │   │
│  │     - Cost (embedding + generation costs)                          │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RESULTS COMPARISON TABLE                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Strategy      │ Precision │ Recall │ Quality │ Latency │ Cost    │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  Fixed-size    │   0.65    │  0.72  │   3.2   │  1.2s   │ $0.008 │   │
│  │  Sentence      │   0.72    │  0.78  │   3.8   │  1.3s   │ $0.009 │   │
│  │  Recursive     │   0.75    │  0.82  │   4.1   │  1.4s   │ $0.010 │   │
│  │  Sliding       │   0.78    │  0.85  │   4.2   │  1.5s   │ $0.012 │   │
│  │  Semantic      │   0.82    │  0.88  │   4.5   │  1.6s   │ $0.011 │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Winner: Semantic Chunking                                                   │
│  - Best precision and recall                                                │
│  - Highest answer quality                                                   │
│  - Acceptable latency and cost                                              │   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Week 3: Advanced Retrieval Architectures

### 1. Vector Database Internals: How HNSW and ANN Algorithms Work

#### HNSW (Hierarchical Navigable Small World) Algorithm

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    HNSW ALGORITHM EXPLAINED                                 │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    HNSW STRUCTURE                                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Multi-Layer Graph Structure                                       │   │
│  │                                                                      │   │
│  │  Layer 2 (Sparse):                                                  │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  A ──────── B ──────── C                                     │ │   │
│  │  │  │           │         │                                      │ │   │
│  │  │  D ──────── E ──────── F                                     │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │  (Fewer nodes, long-range connections)                            │   │
│  │                                                                      │   │
│  │  Layer 1 (Medium):                                                 │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  A ── B ── C ── D                                            │ │   │
│  │  │  │     │     │     │                                          │ │   │
│  │  │  E ── F ── G ── H                                            │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │  (More nodes, medium-range connections)                          │   │
│  │                                                                      │   │
│  │  Layer 0 (Dense - All nodes):                                     │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  A ── B ── C ── D ── E ── F ── G ── H ── I ── J            │ │   │
│  │  │  │     │     │     │     │     │     │     │     │          │ │   │
│  │  │  K ── L ── M ── N ── O ── P ── Q ── R ── S ── T            │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │  (All nodes, short-range connections)                          │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    HNSW SEARCH PROCESS                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Query Vector: [0.23, -0.45, 0.67, ...]                                    │
│                                                                              │
│  Step 1: Start at top layer (Layer 2)                                      │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Entry Point: Random node (e.g., A)                               │   │
│  │  → Search for nearest neighbor in Layer 2                         │   │
│  │  → Found: B (closest in sparse graph)                              │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 2: Move to Layer 1                                                  │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Entry Point: B (from Layer 2)                                   │   │
│  │  → Search neighbors of B in Layer 1                              │   │
│  │  → Found: E (closer to query)                                      │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 3: Move to Layer 0 (Base Layer)                                      │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Entry Point: E (from Layer 1)                                   │   │
│  │  → Search neighbors of E in Layer 0                              │   │
│  │  → Explore local neighborhood                                     │   │
│  │  → Found: F, G, H (candidates)                                    │   │
│  │  → Return top K nearest neighbors                                │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Benefits:                                                                   │
│  ✓ Fast search: O(log n) complexity                                       │   │
│  ✓ High recall: Finds nearest neighbors efficiently                       │   │
│  ✓ Scalable: Works with millions of vectors                               │   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### ANN (Approximate Nearest Neighbor) Algorithms Comparison

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ANN ALGORITHMS COMPARISON                                 │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│  Algorithm      │ Complexity │ Accuracy │ Memory │ Use Case              │
│  ├─────────────────────────────────────────────────────────────────────────┤
│  │  HNSW         │ O(log n)    │ High     │ Medium │ General purpose      │
│  │  IVF          │ O(n/k)      │ Medium   │ Low    │ Large datasets       │
│  │  LSH          │ O(1)        │ Low      │ Low    │ Fast approximate    │
│  │  PQ           │ O(n)        │ Medium   │ Very   │ Memory constrained   │
│  │               │             │          │ Low    │                      │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2. Dense vs. Sparse Retrieval: Solving the Coverage Problem

#### Dense vs. Sparse Retrieval

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DENSE vs. SPARSE RETRIEVAL                                │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    DENSE RETRIEVAL (Semantic Search)                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Use dense embeddings (vectors)                          │   │
│  │                                                                      │   │
│  │  Query: "How to fix a broken computer?"                            │   │
│  │  → Embedding: [0.23, -0.45, 0.67, ..., 0.12] (1536-dim)           │   │
│  │                                                                      │   │
│  │  Documents:                                                        │   │
│  │  Doc 1: "Troubleshooting PC issues"                               │   │
│  │  → Embedding: [0.25, -0.43, 0.65, ..., 0.15]                       │   │
│  │  → Similarity: 0.92 (high - semantic match)                        │   │
│  │                                                                      │   │
│  │  Doc 2: "Computer repair guide"                                    │   │
│  │  → Embedding: [0.24, -0.44, 0.66, ..., 0.14]                       │   │
│  │  → Similarity: 0.89 (high - semantic match)                        │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Understands semantic meaning                                    │   │
│  │  ✓ Handles synonyms and paraphrasing                               │   │
│  │  ✓ Good for conceptual queries                                     │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ May miss exact keyword matches                                  │   │
│  │  ✗ Requires embedding model                                        │   │
│  │  ✗ Computationally expensive                                       │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    SPARSE RETRIEVAL (Keyword Search)                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Approach: Use sparse vectors (TF-IDF, BM25)                        │   │
│  │                                                                      │   │
│  │  Query: "How to fix a broken computer?"                            │   │
│  │  → Sparse Vector: {"how": 0.1, "fix": 0.8, "broken": 0.9,        │   │
│  │                    "computer": 0.7, ...}                          │   │
│  │                                                                      │   │
│  │  Documents:                                                        │   │
│  │  Doc 1: "Fix broken computers - step by step"                     │   │
│  │  → Sparse Vector: {"fix": 0.9, "broken": 0.8, "computer": 0.7,   │   │
│  │                    "step": 0.5, ...}                                │   │
│  │  → Score: 2.4 (high - exact keyword match)                         │   │
│  │                                                                      │   │
│  │  Doc 2: "Troubleshooting PC issues"                                │   │
│  │  → Sparse Vector: {"troubleshooting": 0.6, "PC": 0.5,            │   │
│  │                    "issues": 0.4, ...}                              │   │
│  │  → Score: 0.5 (low - no exact keywords)                            │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Fast and efficient                                              │   │
│  │  ✓ Good for exact keyword matches                                  │   │
│  │  ✓ No model required                                               │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ Misses semantic relationships                                    │   │
│  │  ✗ Doesn't handle synonyms                                         │   │
│  │  ✗ Limited to exact word matches                                  │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3. Implementing Hybrid Retrieval with Reciprocal Rank Fusion (RRF)

#### Hybrid Retrieval Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    HYBRID RETRIEVAL WITH RRF                                 │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    QUERY PROCESSING                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Query: "How to fix a broken computer?"                                     │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │
                           ├──────────────────────┐
                           │                      │
                           ▼                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DENSE RETRIEVAL          SPARSE RETRIEVAL                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  1. Generate Query Embedding                                        │   │
│  │  2. Vector Search (Qdrant)                                          │   │
│  │  3. Return Top K results                                            │   │
│  │                                                                      │   │
│  │  Results:                                                            │   │
│  │  Rank 1: Doc A (score: 0.92)                                       │   │
│  │  Rank 2: Doc B (score: 0.89)                                       │   │
│  │  Rank 3: Doc C (score: 0.85)                                       │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  1. Generate Sparse Vector (BM25)                                  │   │
│  │  2. Keyword Search (Elasticsearch)                                  │   │
│  │  3. Return Top K results                                            │   │
│  │                                                                      │   │
│  │  Results:                                                            │   │
│  │  Rank 1: Doc D (score: 2.4)                                        │   │
│  │  Rank 2: Doc A (score: 2.1)                                        │   │
│  │  Rank 3: Doc E (score: 1.8)                                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                           │                      │
                           └──────────┬───────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RECIPROCAL RANK FUSION (RRF)                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Formula: RRF(d) = Σ 1 / (k + rank_i(d))                                    │
│  where k = 60 (constant), rank_i = rank in list i                          │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Document   │ Dense Rank │ Sparse Rank │ RRF Score │ Final Rank   │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  Doc A       │     1      │     2      │  0.033    │     1        │   │
│  │  Doc B       │     2      │     5      │  0.028    │     2        │   │
│  │  Doc C       │     3      │     6      │  0.025    │     3        │   │
│  │  Doc D       │     10     │     1      │  0.018    │     4        │   │
│  │  Doc E       │     8      │     3      │  0.016    │     5        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Benefits:                                                                   │
│  ✓ Combines strengths of both methods                                      │   │
│  ✓ Better coverage (semantic + keyword)                                    │   │
│  ✓ No need to normalize scores                                             │   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4. Reranking Architectures: Bi-encoders vs. Cross-encoders (Voyage AI)

#### Reranking Comparison

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RERANKING ARCHITECTURES                                   │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    BI-ENCODER RERANKING                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Architecture:                                                       │   │
│  │                                                                      │   │
│  │  Query: "How to fix computer?"                                       │   │
│  │       │                                                              │   │
│  │       ▼                                                              │   │
│  │  ┌──────────────┐                                                    │   │
│  │  │  Encoder     │ → Query Embedding: [0.23, -0.45, ...]            │   │
│  │  └──────────────┘                                                    │   │
│  │                                                                      │   │
│  │  Document: "Computer repair guide"                                   │   │
│  │       │                                                              │   │
│  │       ▼                                                              │   │
│  │  ┌──────────────┐                                                    │   │
│  │  │  Encoder     │ → Doc Embedding: [0.25, -0.43, ...]              │   │
│  │  └──────────────┘                                                    │   │
│  │                                                                      │   │
│  │  Similarity = Cosine(Query Embedding, Doc Embedding)                │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ Fast: Embeddings computed once, cached                           │   │
│  │  ✓ Scalable: Can rerank thousands quickly                          │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ Lower accuracy: No query-document interaction                  │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    CROSS-ENCODER RERANKING                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Architecture:                                                       │   │
│  │                                                                      │   │
│  │  Input: "[CLS] How to fix computer? [SEP] Computer repair guide" │   │
│  │       │                                                              │   │
│  │       ▼                                                              │   │
│  │  ┌──────────────────────────────────────────────────────────────┐ │   │
│  │  │  Cross-Encoder                                                │ │   │
│  │  │  - Processes query and document together                     │ │   │
│  │  │  - Attention mechanism sees full context                      │ │   │
│  │  │  - Outputs relevance score directly                           │ │   │
│  │  └──────────────────────────────────────────────────────────────┘ │   │
│  │       │                                                              │   │
│  │       ▼                                                              │   │
│  │  Relevance Score: 0.92                                              │   │
│  │                                                                      │   │
│  │  Pros:                                                               │   │
│  │  ✓ High accuracy: Full query-document interaction                 │   │
│  │  ✓ Better understanding of context                                │   │
│  │                                                                      │   │
│  │  Cons:                                                               │   │
│  │  ✗ Slow: Must process each query-document pair                    │   │
│  │  ✗ Expensive: Can't cache embeddings                              │   │
│  │  ✗ Limited scale: Typically rerank top 100-1000                   │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    TWO-STAGE RERANKING PIPELINE                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Stage 1: Initial Retrieval (Bi-encoder)                                     │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Query → Vector Search → Top 1000 candidates                       │   │
│  │  (Fast, scalable)                                                   │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Stage 2: Reranking (Cross-encoder)                                          │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Top 1000 → Cross-encoder → Top 10 final results                    │   │
│  │  (Accurate, but slower)                                             │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Best of both worlds: Fast + Accurate                                       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5. The Two-Stage Retrieval Pipeline: LLM Routing for Precision

#### Two-Stage Retrieval with LLM Routing

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TWO-STAGE RETRIEVAL PIPELINE                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    STAGE 1: QUERY UNDERSTANDING                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  User Query: "What are the side effects of medication X?"                   │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  LLM Router                                                          │   │
│  │                                                                      │   │
│  │  Prompt:                                                             │   │
│  │  "Analyze this query and determine:                                 │   │
│  │   1. Query type (factual, explanatory, comparative)                │   │
│  │   2. Required precision (high/medium/low)                          │   │
│  │   3. Expected answer length (short/medium/long)                     │   │
│  │   4. Retrieval strategy (dense/sparse/hybrid)"                     │   │
│  │                                                                      │   │
│  │  Query: {user_query}"                                               │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
│                          ▼                                                   │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Routing Decision:                                                  │   │
│  │  {                                                                  │   │
│  │    "query_type": "factual",                                        │   │
│  │    "precision": "high",                                            │   │
│  │    "strategy": "hybrid",                                           │   │
│  │    "top_k": 20,                                                    │   │
│  │    "rerank": true                                                  │   │
│  │  }                                                                  │   │
│  └───────────────────────┬──────────────────────────────────────────────┘   │
│                          │                                                   │
└──────────────────────────┼───────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    STAGE 2: RETRIEVAL EXECUTION                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Based on routing decision:                                                  │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Strategy: Hybrid Retrieval                                        │   │
│  │                                                                      │   │
│  │  1. Dense Retrieval (top_k=20)                                     │   │
│  │     → Semantic search for related concepts                         │   │
│  │                                                                      │   │
│  │  2. Sparse Retrieval (top_k=20)                                    │   │
│  │     → Keyword search for exact matches                             │   │
│  │                                                                      │   │
│  │  3. RRF Fusion                                                      │   │
│  │     → Combine results                                               │   │
│  │                                                                      │   │
│  │  4. Reranking (Cross-encoder, top_k=10)                             │   │
│  │     → Final precision ranking                                       │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Result: Top 10 highly relevant documents                                   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 6. Lab: Building and Evaluating Your High-Accuracy Retrieval System

### 7. Analyzing Tradeoffs: Cost-Accuracy-Latency (CAL) Framework

#### CAL Framework

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    COST-ACCURACY-LATENCY (CAL) FRAMEWORK                     │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    TRADEOFF ANALYSIS                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Configuration 1: Fast & Cheap                                      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │   │
│  │  │  Accuracy    │  │  Latency     │  │  Cost        │            │   │
│  │  │    70%       │  │  0.5s        │  │  $0.001     │            │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘            │   │
│  │  Strategy: Dense only, no reranking                                │   │
│  │  Use case: High-volume, low-stakes queries                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Configuration 2: Balanced                                          │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │   │
│  │  │  Accuracy    │  │  Latency     │  │  Cost        │            │   │
│  │  │    85%       │  │  1.5s        │  │  $0.005     │            │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘            │   │
│  │  Strategy: Hybrid + Bi-encoder reranking                          │   │
│  │  Use case: General purpose, moderate requirements                 │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Configuration 3: High Accuracy                                     │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │   │
│  │  │  Accuracy    │  │  Latency     │  │  Cost        │            │   │
│  │  │    95%       │  │  3.0s        │  │  $0.015     │            │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘            │   │
│  │  Strategy: Hybrid + Cross-encoder reranking                      │   │
│  │  Use case: Critical applications, high-stakes queries              │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    DECISION MATRIX                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Priority          │ Recommended Configuration                     │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  Cost-sensitive    │ Config 1: Fast & Cheap                        │   │
│  │  Balanced          │ Config 2: Balanced                            │   │
│  │  Accuracy-critical │ Config 3: High Accuracy                      │   │
│  │  Low latency       │ Config 1: Fast & Cheap                        │   │
│  │  High quality      │ Config 3: High Accuracy                      │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 8. Learning from Failure: Metadata Filtering Strategies

#### Metadata Filtering

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    METADATA FILTERING STRATEGIES                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    FILTERING APPROACHES                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Query: "What are the side effects of medication X?"                        │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Pre-Filtering (Before Vector Search)                              │   │
│  │                                                                      │   │
│  │  Filters:                                                           │   │
│  │  - category = "medications"                                        │   │
│  │  - date >= "2020-01-01" (recent info)                              │   │
│  │  - language = "en"                                                  │   │
│  │                                                                      │   │
│  │  → Reduces search space                                            │   │
│  │  → Faster retrieval                                                 │   │
│  │  → But may exclude relevant docs                                    │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Post-Filtering (After Vector Search)                               │   │
│  │                                                                      │   │
│  │  1. Vector search (no filters) → Top 100                           │   │
│  │  2. Apply filters:                                                  │   │
│  │     - category = "medications"                                      │   │
│  │     - date >= "2020-01-01"                                          │   │
│  │  3. Return filtered results                                         │   │
│  │                                                                      │   │
│  │  → Better recall                                                    │   │
│  │  → But slower (searches more docs)                                 │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Hybrid Filtering (Recommended)                                     │   │
│  │                                                                      │   │
│  │  1. Apply strict filters (must-have):                               │   │
│  │     - language = "en"                                               │   │
│  │                                                                      │   │
│  │  2. Vector search in filtered set                                  │   │
│  │                                                                      │   │
│  │  3. Apply soft filters (nice-to-have):                             │   │
│  │     - Boost recent documents                                        │   │
│  │     - Prefer certain categories                                     │   │
│  │                                                                      │   │
│  │  → Balanced approach                                                │   │
│  │  → Good performance + quality                                      │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 9. Framework: Optimizing Data for Targeted Retrieval

---

## Week 4: Mastering Evaluation

### 1. The RAG Evaluation Challenge: Why It's Harder Than Building

### 2. Synthetic Test Set Generation with RAGAS

### 3. LLM-as-a-Judge Evaluation with DeepEval

### 4. Semantic Metrics for Context Quality: Understanding Misalignment

### 5. Comparative Analysis: Forcing Differentiation in LLM-Based Evaluation

### 6. Bootstrapped Golden Datasets: Creating High-Quality Ground Truth

### 7. Framework: Choosing the Right Ground Truth Strategy for Each RAG Iteration

---

## Week 5: Production Engineering & Optimization

### 1. Production RAG Architecture: Latency, Cost, and Observability

### 2. Semantic Caching Deep Dive: Achieving 1250x Speedup with Redis

#### Semantic Caching Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SEMANTIC CACHING WITH REDIS                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    CACHING FLOW                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Query 1: "What are the side effects of medication X?"                      │
│       │                                                                      │
│       ▼                                                                      │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  1. Generate Query Embedding                                        │   │
│  │  2. Check Redis Cache (semantic similarity)                       │   │
│  │  3. If similar query found (similarity > 0.95):                   │   │
│  │     → Return cached answer (latency: ~10ms)                       │   │
│  │  4. If not found:                                                  │   │
│  │     → Run full RAG pipeline                                        │   │
│  │     → Store result in cache                                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Query 2: "What adverse effects does medication X have?"                   │
│       │                                                                      │
│       ▼                                                                      │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  1. Generate Query Embedding                                        │   │
│  │  2. Check Redis Cache                                              │   │
│  │  3. Found similar query (similarity: 0.97)                        │   │
│  │     → Return cached answer (1250x faster!)                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

Benefits:
  ✓ 1250x speedup for similar queries
  ✓ Reduced LLM API costs
  ✓ Lower latency
  ✓ Better user experience
```

### 3. Building a Production Backend with FastAPI and Streaming Responses

### 4. Developing a Chatbot UI with Streamlit

### 5. Integrating Opik for RAG Observability and Tracing

### 6. Smart Retries, Adaptive Prompting, and Cache Invalidation Strategies

---

## Week 6: Advanced Architectures & Deployment

### 1. Beyond RAG: Cache Augmented Generation (CAG) and Agentic Architectures

#### CAG Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CACHE AUGMENTED GENERATION (CAG)                         │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    CAG PIPELINE                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Query: "What are the side effects of medication X?"                        │
│                                                                              │
│  Step 1: Check Cache                                                        │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Semantic Cache Lookup                                              │   │
│  │  → Found similar query?                                             │   │
│  │  → If yes: Return cached answer (fast path)                        │   │
│  │  → If no: Continue to Step 2                                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 2: Retrieval                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Vector Search → Retrieve relevant documents                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 3: Generation                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  LLM generates answer from context                                  │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Step 4: Cache Update                                                       │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Store query embedding + answer in cache                            │   │
│  │  → Future similar queries can use cached answer                    │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2. Advanced Query Understanding: Expansion, Decomposition, and Multi-Step RAG

### 3. Hybrid Retrieval: Knowledge Graphs, Code Search, and Multi-modal Data

### 4. Dynamic Retrieval: Query Routing and RAG-as-a-Pluggable-Tool

### 5. Production Deployment: Docker, Cloud Platforms, and Security Best Practices

### 6. The CAP Theorem for LLMs: Understanding Tradeoffs (Cost, Accuracy, Latency)

### 7. Capstone Project: Design, Build, and Deploy Your Own Production RAG System

---

## Conclusion

This comprehensive guide covers all aspects of building production-ready RAG systems, from foundational concepts to advanced architectures and deployment strategies. Each topic includes visual diagrams and practical examples to help you understand and implement RAG solutions effectively.

---

*Document Version: 1.0*  
*Last Updated: 2025*

