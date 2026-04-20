#!/usr/bin/env nextflow

/*
 * ============================================================
 *  STARTER NEXTFLOW PIPELINE
 * ============================================================
 *  This is a beginner-friendly Nextflow pipeline.
 *  It demonstrates the core concepts:
 *    - Channels  : how data flows between processes
 *    - Processes : the individual steps/tasks
 *    - Workflow  : how processes connect together
 * ============================================================
 */

// Nextflow DSL2 is the modern syntax (recommended)
nextflow.enable.dsl=2

// ------------------------------------
// PARAMETERS
// Parameters let users customize runs
// via --param_name on the command line
// ------------------------------------
params.input   = "$projectDir/data/*.txt"   // glob pattern for input files
params.outdir  = "$projectDir/results"       // where outputs go
params.greeting = "Hello"                    // a simple example param

log.info """
    ====================================
     S T A R T E R   P I P E L I N E
    ====================================
    input   : ${params.input}
    outdir  : ${params.outdir}
    ====================================
    """.stripIndent()


// ============================================================
// PROCESSES
// Each process is an isolated task (runs in its own directory).
// It declares: inputs, outputs, and the script to run.
// ============================================================

/*
 * STEP 1: Count the number of lines in each input file
 */
process COUNT_LINES {

    // Tag labels each job in the log so you know which file it processed
    tag "$sample_id"

    // Where to publish (copy) the output files when done
    publishDir "${params.outdir}/counts", mode: 'copy'

    input:
    tuple val(sample_id), path(input_file)  // a tuple: name + file

    output:
    tuple val(sample_id), path("${sample_id}.count.txt")  // pass to next step

    script:
    """
    echo "Counting lines in ${input_file}..."
    wc -l < ${input_file} > ${sample_id}.count.txt
    """
}

/*
 * STEP 2: Add a greeting to each count result
 */
process ADD_GREETING {

    tag "$sample_id"

    publishDir "${params.outdir}/greeted", mode: 'copy'

    input:
    tuple val(sample_id), path(count_file)
    val greeting                            // a simple value channel

    output:
    path("${sample_id}.result.txt")

    script:
    """
    echo "${greeting} from sample: ${sample_id}" > ${sample_id}.result.txt
    echo "Line count: \$(cat ${count_file})" >> ${sample_id}.result.txt
    """
}


// ============================================================
// WORKFLOW
// This is where you wire processes together.
// The output channel of one process feeds the input of another.
// ============================================================

workflow {

    // --- Create input channel ---
    // Channel.fromFilePairs creates tuples of (sample_id, file)
    // The sample_id is inferred from the filename (strips extension)
    input_ch = Channel
        .fromPath(params.input)
        .map { file -> tuple(file.baseName, file) }

    // --- Run Step 1 ---
    COUNT_LINES(input_ch)

    // --- Run Step 2 (uses output of Step 1) ---
    // COUNT_LINES.out is the output channel from the previous process
    ADD_GREETING(COUNT_LINES.out, params.greeting)

    // --- View results in the log (optional, great for debugging) ---
    ADD_GREETING.out.view { file -> "✅ Output: $file" }
}
