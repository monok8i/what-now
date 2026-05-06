"""Data endpoints for the API."""

from fastapi import APIRouter


router = APIRouter(prefix="/data", tags=["data"])


# @router.post(
#     "/",
#     response_model=MatchingBenefitsResponse,
#     status_code=status.HTTP_200_OK,
# )
# async def search_matching_benefits(
#     request: Request,
#     questionnaire: CaregiverQuestionnaireRequest,
#     db_session: AsyncSession = Depends(get_db),
#     questionnaire_processor: QuestionnaireProcessor = Depends(
#         get_questionnaire_processor
#     ),
#     benefit_matcher: BenefitMatcher = Depends(BenefitMatcher),
# ) -> MatchingBenefitsResponse:
#     """Search for benefits and services matching questionnaire data.

#     This endpoint:
#     1. Parses the questionnaire to extract search criteria
#     2. Searches the database for matching benefits/services
#     3. Returns formatted results with relevance explanations

#     Args:
#         questionnaire: The completed questionnaire data
#         db: Database session (injected)
#         questionnaire_processor: QuestionnaireProcessor instance (injected)
#     Returns:
#         Matching benefits and services with explanations

#     Raises:
#         HTTPException: If search fails or data is invalid
#     """
#     try:
#         # Generate submission ID
#         submission_id = str(uuid.uuid4())

#         # Convert Pydantic model to dict
#         data_dict = questionnaire.model_dump()

#         # Step 1: Extract search criteria from questionnaire
#         criteria = questionnaire_processor.parse_questionnaire(data_dict)

#         # Step 2: Search database for matching benefits
#         matching_benefits = await benefit_matcher.find_matching_benefits(
#             db_session, criteria
#         )

#         # Step 3: Format results
#         formatted_results = benefit_matcher.format_results(matching_benefits, criteria)

#         # Convert to Pydantic models
#         benefit_results = [
#             BenefitServiceResult(**result) for result in formatted_results
#         ]

#         ai_response = await questionnaire_processor.generate_ai_explanation(
#             criteria, formatted_results
#         )

#         result = MatchingBenefitsResponse(
#             message=f"Found {len(benefit_results)} relevant benefits and services.",
#             submission_id=submission_id,
#             total_matches=len(benefit_results),
#             search_criteria=criteria,
#             matching_benefits=benefit_results,
#             questionnaire_data=questionnaire,
#             ai_response=ai_response,
#         )

#         request.app.state.chat_metadata = result
#         request.app.state.chat_conversaion_history = []

#     except Exception as e:
#         raise HTTPException(
#             status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
#             detail=f"Search error: {str(e)}",
#         ) from e

#     return result


# @router.get(
#     "/map",
#     status_code=status.HTTP_200_OK,
#     response_model=list[ExtractedServiceResponse],
# )
# async def get_map_data(
#     db_session: AsyncSession = Depends(get_db),
#     map_data_service: MapDataExtractedService = Depends(get_map_data_service),
# ):
#     """Example endpoint to return data for map visualization."""
#     # This is a placeholder implementation. In a real application, you would query the database
#     # and return relevant data for the map visualization.
#     map_data = await map_data_service.get_map_data(db_session)

#     return map_data
