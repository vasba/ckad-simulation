#!/bin/bash

# Master validation script for all CKAD simulation questions
echo "========================================"
echo "CKAD Simulation - Master Validation Script"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

TOTAL_QUESTIONS=22
PASSED_QUESTIONS=0
FAILED_QUESTIONS=0

# Function to run validation for a specific question
validate_question() {
    local question_num=$1
    local question_dir="/home/vbaluta/git/ckad-simulation/question-$(printf "%02d" $question_num)"
    
    if [[ -d "$question_dir" ]] && [[ -f "$question_dir/validate.sh" ]]; then
        echo "Running validation for Question $question_num..."
        cd "$question_dir"
        
        if ./validate.sh; then
            echo -e "${GREEN}✅ Question $question_num: PASSED${NC}"
            ((PASSED_QUESTIONS++))
        else
            echo -e "${RED}❌ Question $question_num: FAILED${NC}"
            ((FAILED_QUESTIONS++))
        fi
        echo ""
    else
        echo -e "${YELLOW}⚠️  Question $question_num: Validation script not found${NC}"
        echo ""
    fi
}

# Parse command line arguments
if [[ $# -eq 0 ]]; then
    # Run all validations
    echo "Running validation for all questions..."
    echo ""
    
    for i in {1..22}; do
        validate_question $i
    done
elif [[ $1 == "help" ]] || [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
    echo "Usage: $0 [question_number|all|help]"
    echo ""
    echo "Examples:"
    echo "  $0           # Run validation for all questions"
    echo "  $0 all       # Run validation for all questions"
    echo "  $0 1         # Run validation for question 1 only"
    echo "  $0 5         # Run validation for question 5 only"
    echo "  $0 help      # Show this help message"
    exit 0
elif [[ $1 == "all" ]]; then
    # Run all validations
    echo "Running validation for all questions..."
    echo ""
    
    for i in {1..22}; do
        validate_question $i
    done
elif [[ $1 =~ ^[0-9]+$ ]] && [[ $1 -ge 1 ]] && [[ $1 -le 22 ]]; then
    # Run validation for specific question
    validate_question $1
    exit $?
else
    echo -e "${RED}Error: Invalid argument '$1'${NC}"
    echo "Use '$0 help' for usage information"
    exit 1
fi

# Print summary
echo "========================================"
echo "VALIDATION SUMMARY"
echo "========================================"
echo -e "Total Questions: $TOTAL_QUESTIONS"
echo -e "${GREEN}Passed: $PASSED_QUESTIONS${NC}"
echo -e "${RED}Failed: $FAILED_QUESTIONS${NC}"

if [[ $FAILED_QUESTIONS -eq 0 ]]; then
    echo ""
    echo -e "${GREEN}🎉 All validations passed! Great job!${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}💥 Some validations failed. Please review the failed questions.${NC}"
    exit 1
fi
