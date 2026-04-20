# 🧬 Nextflow Starter Pipeline

A beginner-friendly Nextflow pipeline to help you learn the core concepts.

## 📁 Project Structure

```
nextflow-starter/
├── main.nf            # Main pipeline definition
├── nextflow.config    # Configuration (params, profiles)
├── data/              # Input data
│   ├── sampleA.txt
│   └── sampleB.txt
├── results/           # Pipeline outputs (generated on run)
└── README.md
```

## 🧠 Key Concepts Demonstrated

| Concept | Where | What it does |
|---|---|---|
| **Parameters** | `params.*` in `main.nf` | User-configurable inputs via `--param` |
| **Channels** | `Channel.fromPath(...)` | Streams data between processes |
| **Processes** | `process COUNT_LINES` | Isolated tasks with inputs/outputs/script |
| **Workflow** | `workflow { }` block | Wires processes together |
| **publishDir** | Inside each process | Copies results to your output folder |
| **Profiles** | `nextflow.config` | Switch between local/Docker/HPC execution |

## 🚀 Installation

### 1. Install Nextflow
```bash
# Requires Java 11+
java -version

# Install Nextflow
curl -s https://get.nextflow.io | bash
chmod +x nextflow
sudo mv nextflow /usr/local/bin/  # optional: make it available system-wide
```

### 2. Verify installation
```bash
nextflow -version
```

## ▶️ Running the Pipeline

### Basic run (local, no containers)
```bash
nextflow run main.nf
```

### With custom parameters
```bash
nextflow run main.nf --input "data/*.txt" --outdir my_results --greeting "Hi"
```

### With Docker
```bash
nextflow run main.nf -profile docker
```

### Resume a failed run (Nextflow caches completed steps!)
```bash
nextflow run main.nf -resume
```

## 📊 Expected Output

After running, the `results/` folder will contain:
```
results/
├── counts/
│   ├── sampleA.count.txt   # line count for sampleA
│   └── sampleB.count.txt
└── greeted/
    ├── sampleA.result.txt  # greeting + count
    └── sampleB.result.txt
```

## 🔍 Useful Commands

```bash
# List all runs and their status
nextflow log

# Show detailed info about a specific run
nextflow log <run_name> -f name,status,exit,duration

# Clean up work directory (keeps results/)
nextflow clean -f
```

## 📚 Learning Resources

- [Nextflow Docs](https://www.nextflow.io/docs/latest/)
- [nf-core pipelines](https://nf-co.re/) — community best-practice pipelines
- [Nextflow Training](https://training.nextflow.io/) — free official training

## 🛠️ Next Steps

1. Replace the sample bash scripts with your actual tools (e.g. `bwa`, `samtools`, `python`)
2. Add a `modules/` directory to organize processes as your pipeline grows
3. Explore [nf-core modules](https://nf-co.re/modules) for ready-made process definitions
